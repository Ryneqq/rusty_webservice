#[macro_use]
extern crate diesel;

mod auth;
mod routes;
mod schema;
mod db;

use diesel::prelude::*;
use self::db::models::Post;
use self::schema::posts::dsl::*;



fn main() {
    // routes::serve();


    let connection = db::establish_connection();

    db::create_post(&connection, "John Wick 3", "He offcialy killed with every possible item right now");
    let posts = db::read_posts(&connection);

    println!("Displaying {} posts", posts.len());
    for post in posts {
        println!("{}", post.title);
        println!("----------\n");
        println!("{}", post.body);
    }
}
