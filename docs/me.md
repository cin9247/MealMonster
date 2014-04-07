Host: http://meals-on-wheels.herokuapp.com/

#Eingeloggten User abfragen

Liefert den eingeloggten User und den mit ihm verknüpften Kunden zurück.

##Request

`GET /api/v1/me.json`

Beispiel: `http://meals-on-wheels.herokuapp.com/api/v1/me.json`

##Response

###Status

`200 OK`

###Body

```JSON
{
  "user": [
    {
      "id": 42,
      "name": "kunde-01",
      "customer": {
        "id": 1581,
        "forename": "Peter",
        "surname": "Mustermann"
      }
    }
  ]
}
```
