# coding=utf-8
import requests
import json
import random

class Zomato:

    def __init__(self, **kwargs):
        super(Zomato).__init__(**kwargs)

    def categories(self, category, key, url):
        headers = {'Accept': 'application/json', 'user-key': key}
        req = requests.get(url + "categories", headers=headers).content.decode("utf-8")
        r = json.loads(req)
        for i in r['categories']:
            if i['categories']['name'] == category:
                return i['categories']['id']

    def city(key, url, name): #get id atraves do nome da cidade (para usar nas proximas funções)
        name.replace(' ', '%20')
        headers = {'Accept': 'application/json', 'user-key': key}
        req = requests.get(url + "cities?q="+name, headers=headers).content.decode("utf-8")
        r = json.loads(req)
        if 'id' in r['location_suggestions'][0]:
            return r['location_suggestions'][0]['id']

    def cuisines(key, url,type,id_city):
        headers = {'Accept': 'application/json', 'user-key': key}
        req = requests.get(url + "cuisines?city_id="+str(id_city), headers=headers).content.decode("utf-8")
        r = json.loads(req)
        for i in r['cuisines']:
            if i['cuisine']['cuisine_name'] == type:
                return i['cuisine']['cuisine_id']

    def establishments(self, key,url,typeEstablishment,id_city):
        headers = {'Accept': 'application/json', 'user-key': key}
        req = requests.get(url + "establishments?city_id=" + str(id_city), headers=headers).content.decode("utf-8")
        r = json.loads(req)
        for i in r['establishments']:
            if i['establishment']['name'] == typeEstablishment:
                return i['establishment']['id']

    def locations(self, key, url, name):
        headers = {'Accept': 'application/json', 'user-key': key}
        req = requests.get(url + "locations?query=" + name, headers=headers).content.decode(
            "utf-8")
        r = json.loads(req)
        if r['location_suggestions']:
            return r['location_suggestions'][0]['city_id']

    #Search for Italian restaurants in "New York City, NY"
    def search(self, typeRequest, category, typeCuisine, location, sitio, price, limitPrice, score, limitScore, sort, order, restaurantName, key, url):
        found = 0
        start = 0
        idCategory = ''
        idCuisine = ''
        idCity = ''
        answer = []

        if(category != '' and restaurantName == ''):
            idCategory = self.categories(category, key,url)
        else:
            idCategory = ''

        if(location != ''):
            idCity = self.locations(key, url, location)

        if(typeCuisine != ''):
            idCuisine = Zomato.cuisines(key, url,typeCuisine, idCity)

        apiRestaurantName = restaurantName.replace(' ', '%20')


        headers = {'Accept': 'application/json', 'user-key': key}

        #to go through the 4 pages
        for k in range (4):

            req = requests.get(url + "search?entity_id=" + str(idCity) + "&sort=" + sort + "&order=" + order + "&entity_type=city&category=" + str(idCategory) + "&cuisines=" + str(idCuisine) + "&start=" + str(start) + "&count=20&q=" + apiRestaurantName,headers=headers).content.decode("utf-8")

            r = json.loads(req)

            for i in range(len(r['restaurants'])):
                if(restaurantName == ''):
                    if (r['restaurants'][i]['restaurant']['location']['locality'] == sitio):
                        #se tem limites de preço
                        if (limitPrice != 404):

                            priceRange = float(r['restaurants'][i]['restaurant']['price_range'])

                            if ((limitPrice == -1 and priceRange < price) or (limitPrice == 0 and priceRange == price) or (limitPrice == 1 and priceRange > price)):

                                found = 1

                                answer.append(r['restaurants'][i]['restaurant'])


                        elif (limitScore != 404): # se tem limites de score
                            userRating = float(r['restaurants'][i]['restaurant']['user_rating']['aggregate_rating'])

                            if((limitScore == -1 and userRating < score) or (limitScore == 0 and userRating == score) or (limitScore == 1 and userRating > score)):
                                found = 1

                                answer.append(r['restaurants'][i]['restaurant'])


                        else:
                            found = 1
                            answer.append(r['restaurants'][i]['restaurant'])


                elif(r['restaurants'][i]['restaurant']['name'] == restaurantName):
                    found = 1
                    answer.append(r['restaurants'][i]['restaurant'])

                start += 20

        # WE FOUND WHAT WE WANT
        if (found):

            randomRest = answer[random.randint(0, len(answer)-1)]

            if (typeRequest == 'restaurantName'):
                return randomRest['name'] + ' é uma boa escolha.'

            elif (typeRequest == 'address'):
                return 'Fica em: ' + randomRest['location']['address']

            elif (typeRequest == 'contact'):
                return 'É este: ' + randomRest['phone_numbers']
        else:
            return ''


