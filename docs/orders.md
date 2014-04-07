Host: http://meals-on-wheels.herokuapp.com/

#Menu bestellen

##Request

`POST /api/v1/orders.json`

###Parameters

* `offering_id`: Integer
* `customer_id`: Integer
* `note`: String

##Response

###Status

`201 Created`

###Body

```JSON
{
  "order": {
    "id": 334,
    "note": "Could you guys please cook below 50°C?",
    "customer": {
      "forename": "Peter"
    }
  }
}
```

#Bestellungen einsehen

Liefert alle Bestellungen zwischen Tag `from` und `to` des Kunden mit der id `customer_id` zuruück.

##Request

`GET /api/v1/customers/:customer_id/orders`

###Parameters

* `customer_id`: Integer
* `from`: String (ISO 8601, format: *JJJJ-MM-TT*)
* `to`: String (ISO 8601, format: *JJJJ-MM-TT*)

##Response

###Status

`200 OK`

###Body

```JSON
{
   "orders":[
      {
         "id":80,
         "date":"2014-02-26",
         "offerings":[
            {
               "id":30,
               "name":"Menü 1",
               "meals":[
                  {
                     "id":39,
                     "name":"Grießsuppe"
                  },
                  {
                     "id":40,
                     "name":"Piccata von der Pute in Napolisoße, Gabelspaghetti und Mischgemüse"
                  },
                  {
                     "id":41,
                     "name":"Dessertbecher"
                  }
               ]
            }
         ]
      }
   ]
}
```

#Bestellung auslieferen

Markiert die Bestellung mit der id `order_id` als ausgeliefert.

##Request

`PUT /api/v1/orders/:order_id/deliver`

###Parameters

* `order_id`: Integer

##Response

###Status

`204 No Content`

###Body

*Empty*


#Bestellung einladen

Markiert die Bestellung mit der id `order_id` als eingeladen.

##Request

`PUT /api/v1/orders/:order_id/load`

###Parameters

* `order_id`: Integer

##Response

###Status

`204 No Content`

###Body

*Empty*


#Notiz zur Bestellung erstellen

Erstellt ein Ticket für diese Bestellung.

##Request

`POST /api/v1/orders/:order_id/note`

###Parameters

* `note`: String

##Response

###Status

`204 No Content`

###Body

*Empty*


#Bestellung stornieren

Storniert die Bestellung mit der id `order_id` und erstellt ein dazugehöriges Service-Ticket.

##Request

`POST /api/v1/orders/:order_id/cancel`

###Parameters

##Response

###Status

`201 Created`

###Body

*Empty*
