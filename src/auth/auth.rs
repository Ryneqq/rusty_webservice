pub struct Auth<'a> {
    login: &'a str,
    password: &'a str
}

impl<'a> Auth<'a> {
    pub fn new(login: &'a str, password: &'a str) -> Self {
        Auth {
            login,
            password
        }
    }

    // TODO: Result<Abilities, Error>
    pub fn auth(self) -> Result<(), ()> {
        Ok(())
    }
}