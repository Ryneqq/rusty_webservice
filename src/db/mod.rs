pub mod models;

use diesel::prelude::Connection;
use diesel::sqlite::SqliteConnection;
use diesel::RunQueryDsl;
use diesel::query_dsl::select_dsl::SelectDsl;
use dotenv::dotenv;
use std::env;
use self::models::{Post, NewPost};
use crate::schema::posts;

pub fn create_post<'a>(conn: &SqliteConnection, title: &'a str, body: &'a str) -> usize {
    let new_post = NewPost {
        title: title,
        body: body,
    };

    diesel::insert_into(posts::table)
        .values(&new_post)
        .execute(conn)
        .expect("Error saving new post")
}

fn read_posts(conn: &SqliteConnection) -> Vec<Post> {
    let results = posts
        .load::<Post>(conn)
        .expect("Error loading posts")
}

// fn read_all_posts(conn: &dyn Connection<Backend::Sqlite>) -> Vec<Post> {
//     posts::table
//         .select(posts::title)
//         .load::<Post>(&conn)
//         .expect("Could't read posts")
// }

pub fn establish_connection() -> SqliteConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");
    SqliteConnection::establish(&database_url)
        .expect(&format!("Error connecting to {}", database_url))
}