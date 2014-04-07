Host: http://meals-on-wheels.herokuapp.com/

#Angebotene Menus abfragen

##Request
```
GET /api/v1/offerings.json?from=2013-10-08&to=2013-10-09
```

```
GET /api/v1/offerings.json?date=2013-10-08
```

##Response

###Status

`200 OK`

###Body
```JSON
{
  "offerings": [
    {
      "id": 1,
      "date": "2013-10-08",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Nürnberger Würstchen auf Sauerkraut",
          "bread_units": 4.2,
          "kilojoules": 1522
        },
        {
          "name": "Bananenquark",
          "bread_units": 1.6,
          "kilojoules": 740
        }
      ]
    },
    {
      "id": 2,
      "date": "2013-10-08",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Spaghetti mit vegetarischer Bolognese",
          "bread_units": 3.5,
          "kilojoules": 1231
        },
        {
          "name": "Erdbeerquark",
          "bread_units": 1.5,
          "kilojoules": 752
        }
      ]
    },
    {
      "id": 3,
      "date": "2013-10-08",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Obstsalat",
          "bread_units": 0.2,
          "kilojoules": 331
        }
      ]
    },
    {
      "id": 4,
      "date": "2013-10-09",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Nürnberger Würstchen auf Sauerkraut",
          "bread_units": 4.2,
          "kilojoules": 1522
        },
        {
          "name": "Bananenquark",
          "bread_units": 1.6,
          "kilojoules": 740
        }
      ]
    },
    {
      "id": 5,
      "date": "2013-10-09",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Spaghetti mit vegetarischer Bolognese",
          "bread_units": 3.5,
          "kilojoules": 1231
        },
        {
          "name": "Erdbeerquark",
          "bread_units": 1.5,
          "kilojoules": 752
        }
      ]
    },
    {
      "id": 6,
      "date": "2013-10-09",
      "meals": [
        {
          "name": "Rote Beete",
          "bread_units": 0.4,
          "kilojoules": 240
        },
        {
          "name": "Obstsalat",
          "bread_units": 0.2,
          "kilojoules": 331
        }
      ]
    }
  ]
}
```
