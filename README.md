Authors Api
===

## Interacting with the API:

1. Create a new author:  
`http://localhost:4000/api/authors/`
	```
	{
		"author": {
			"first_name": "Test",
			"last_name": "Test",
			"age": 22	
		}
	}
	```

2. Create a post request to create a session for this author  
`http://localhost:4000/api/sessions/`
	```
	{
		"author": {
			"first_name": "Test",
			"last_name": "Test",
			"age": 22	
		}
	}
	```

3. Add a header kvp to access authorized routes:  
`key: authorization`  
`value: Token token=TOKEN_HERE`  
where `TOKEN_HERE` is a returned token from 2.  


4. Access other api routes available to author with an active session  
`[list articles]` http://localhost:4000/api/articles  
`[list authors]` http://localhost:4000/api/authors  
`[edit an author]` http://localhost:4000/api/authors/:id   
`[create an article]` http://localhost:4000/api/articles  
`[delete an article]` http://localhost:4000/api/articles/:id  
	```
	{
		"article": {
			"body": "some body",
			"description": "some description",
			"published_date": "2010-04-17T14:00:00Z",
			"title": "some title",
			"owner_id": 1
		}
	}
	```

## Setup

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Tests
You can run tests with the `mix test` command.
