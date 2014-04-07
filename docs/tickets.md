Host: http://meals-on-wheels.herokuapp.com/

#Ticket eröffnen

##Request

`POST /api/v1/tickets.json`

###Parameters

* `customer_id`: Integer
* `title`: String
* `body`: String

##Response

###Status

`201 Created`

###Body

```JSON
{
  "ticket": {
    "id": 334,
    "title": "Daten falsch",
    "body": "Ich bin umgezogen und wohne nun in ...",
    "customer": {
      "id": 23,
      "forename": "Peter"
    }
  }
}
```


