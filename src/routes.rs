use crate::auth::Auth;
use rouille::{Request, Response, router, try_or_400, post_input};
use std::collections::HashMap;
use std::io;
use std::sync::Mutex;

#[derive(Debug, Clone)]
struct SessionData { login: String }

pub fn serve() {
    let sessions_storage: Mutex<HashMap<String, SessionData>> = Mutex::new(HashMap::new());

    println!("Now listening on localhost:8000");
    rouille::start_server("localhost:8000", move |request| {
        rouille::log(&request, io::stdout(), || {
            rouille::session::session(request, "SID", 3600, |session| {
                let mut session_data = if session.client_has_sid() {
                    match sessions_storage.lock() {
                        Ok(data) => data,
                        Err(poisoned) => poisoned.into_inner(),
                    }.get(session.id()).cloned()
                } else {
                    None
                };

                let response = routes(&request, &mut session_data);

                if let Some(d) = session_data {
                    sessions_storage.lock().unwrap().insert(session.id().to_owned(), d);
                } else if session.client_has_sid() {
                    sessions_storage.lock().unwrap().remove(session.id());
                }

                response
            })
        })
    });
}

fn routes(request: &Request, mut session_data: &mut Option<SessionData>) -> Response {
    router!(request,
        (GET) (/) => {
            json_response()
        },
        (POST) (/login) => {
            login(request, &mut session_data)
        },
        (POST) (/logout) => {
            logout(request, &mut session_data)
        },
        _ => {
            Response::empty_404()
        }
    )
}

fn login(request: &Request, session_data: &mut Option<SessionData>) -> Response {
    let data = try_or_400!(
        post_input!(request, {
            login: String,
            password: String,
        }
    ));

    match Auth::new(&data.login, &data.password).auth() {
        Ok(_) => {
            *session_data = Some(SessionData { login: data.login });
            Response::redirect_303("/")
        },
        Err(_) => Response::json(&format!("{{}}")).with_status_code(401),
    }
}

fn logout(_request: &Request, session_data: &mut Option<SessionData>) -> Response {
    *session_data = None;

    Response::empty_204()
}

fn html_response() -> Response {
    Response::html(
    r#"
        <p>Hint: in this example all passwords that start with the letter 'b'
            (lowercase) are valid.</p>
        <form action="/login" method="POST">
            <input type="text" name="login" placeholder="Login" />
            <input type="password" name="password" placeholder="Password" />
            <button type="submit">Go!</button>
        </form>
        <p>Or you can try <a href="/private">going to the private area</a>
            without logging in, but you will be redirected back here.</p>
    "#)
}

fn json_response() -> Response {
    Response::json(
        &format!(r#"
            {{
                "dummy_json" = true
            }}
        "#)
    )
}