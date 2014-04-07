Host: http://meals-on-wheels.herokuapp.com/

#Touren abfragen

Liefert alle Touren zurück, die für den Tag `date` vorgesehen sind.

##Request

`GET /api/v1/tours.json`

Beispiel: `http://meals-on-wheels.herokuapp.com/api/v1/tours.json?date=2013-11-11`

###Parameters

* `date`: String (ISO 8601, format: *JJJJ-MM-TT*)

##Response

###Status

`200 OK`

###Body

```JSON
{
  "tours": [
    {
      "id": 42,
      "name": "Sonntags-Tour #1",
      "driver": {
        "id": 4,
        "name": "Max Blitz"
      }
    },
    {
      "id": 43,
      "name": "Sonntags-Tour #2",
      "driver": {
        "id": 6,
        "name": Peter Pan"
      }
    }
  ]
}
```

#Tour abfragen

Liefert alle Stationen für die angefragte Tour zurück. Dabei werden nur die Kunden berücksichtigt, die an dem Tag `date` auch Essen bestellt haben.

##Request

`GET /api/v1/tours/:id.json`

Beispiel: `http://meals-on-wheels.herokuapp.com/api/v1/tours/13.json?date=2013-11-11`

###Parameters

* `id`: Integer
* `date`: String (ISO 8601, format: *JJJJ-MM-TT*)

##Response

###Status

`200 OK`

###Body

```JSON
{
  "tour": {
    "id": 42,
    "name": "Tour #1",
    "stations": [
      {
        "customer": {
          "id": 42,
          "forename": "Max",
          "surname": "Mustermann",
          "address": {
            "street_name": "Hausweg",
            "street_number": "32",
            "postal_code": "41742",
            "city": "Munich"
          },
          "order": {
            "id": 76,
            "offerings": [
              {
                "id": 42,
                "name": "Hauptgericht 1",
                "meals": [
                  {
                    id: 12,
                    name: "Schweineschnitzel"
                  },
                  {
                    id: 32,
                    name: "Pudding"
                  }
                ]
              },
              {
                "id": 24,
                "name": "Frühstück"
              }
            ],
            "delivered": false,
            "loaded": false
          }
        },
      },
    ]
  }
}
```

#Schlüssel einer Tour abfragen

Liefert alle Schlüssel zurück, die für diese Tour an diesem Tag benötigt werden.

##Request

`GET /api/v1/tours/:tour_id/keys.json`

Beispiel: `http://meals-on-wheels.herokuapp.com/api/v1/tours/13/keys.json?date=2013-11-11`

###Parameters

* `tour_id`: Integer
* `date`: String (ISO 8601, format: *JJJJ-MM-TT*)

##Response

###Status

`200 OK`

###Body

```JSON
{
  "keys": [
    {
      "id": 32,
      "name": "Schlüssel 4",
      "customer_id": 2
    },
    {
      "id": 41,
      "name": "Schlüssel 12",
      "customer_id": 4
    }
  ]
}
```
