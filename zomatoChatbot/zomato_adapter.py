# coding=utf-8

import nltk
import pickle
from chatterbot.conversation import Statement
from chatterbot.conversation import Response
from chatterbot.logic import LogicAdapter
import zomato_api
from chatterbot.trainers import ListTrainer


# EXAMPLES:
# 'Diz-me um sítio para jantar no Chiado com menos de 10 euros'
# 'Podes me dizer por favor qual o sítio mais barato para almocar no Chiado que tenha um score mínimo de 3 estrelas?'
# 'Qual o restaurante italiano no Bairro Alto com o preço mais baixo?'
# 'Qual o melhor restaurante para comer no Chiado com um score superior a quatro?'
# 'Podes me dizer por favor qual o sítio para almocar no Chiado que tenha um score mínimo de 4 estrelas?
# Qual o restaurante na Saldanha com o score mais alto?
# 'DIz me a localização do Boa-Bao
#  quero tomar cafe na Saldanha inferior a 10 euros e com no mínimo 4 estrelas
# 'Diz me a localizacao do Choupana Caffé'

# 'qual a localização da República dos Cachorros?'
# 'sabes o contacto do Mucaba Café Grill?'
# 'A estas horas qual o restaurante onde podemos comer aqui perto?'
# 'eu e mais 2 amigos queremos ir a Lisboa tomar café. Que sítio recomendas?' #subentede-se que é para ir buscar o restaurante com melhor score/rating

#cuidado com 'Baixa' do Porto e de Lisboa
#CUIDADO COM OS VARIOS TIPOS DE COZINHA
#" GOSTA DE TAILANDES??"

class ZomatoLogicAdapter(LogicAdapter):
    answer = ''

    def __init__(self, **kwargs):
        super(ZomatoLogicAdapter, self).__init__(**kwargs)
        self.key = kwargs.get('key')
        self.url = kwargs.get('url')

    def process(self, statement):
        zomatoApi = zomato_api.Zomato()
        typeRequest = 'restaurantName'
        location = ''
        price = -1
        typeCuisine = ''
        limitPrice = 404
        limitScore = 404
        sort = ''
        order = ''
        score = -1
        category = 'Dinner'
        typeLimit = 0
        check = 0
        starWord = 0
        euroWord = 0
        restaurantName = ''


        user_input = statement.text

        tagger = pickle.load(open("tagger.pkl", 'rb'))
        portuguese_sent_tokenizer = nltk.data.load("tokenizers/punkt/portuguese.pickle")
        sentences = portuguese_sent_tokenizer.tokenize(user_input)
        tags = [tagger.tag(nltk.word_tokenize(sentence)) for sentence in sentences]

        tags = tags[0]

        # LETS COLLECT THE KEYWORDS BASED ON SEMANTIC RULES
        for i, (val, tag) in enumerate(tags):
            valCopy = val.lower()

            # LOCATION
            if ((valCopy == 'no' or valCopy == 'na' or valCopy == 'em') and tags[i + 1][1] == 'NOUNP' and i+1 < len(tags)):
                location = tags[i + 1][0]
                if(i+2 < len(tags)):
                    for j, (val1, tag1) in enumerate(tags[i + 2:]):
                        val1Copy = val1.lower()
                        if ( tag1 != 'NOUNP' and val1Copy != 'de' and val1Copy != 'do' and val1Copy != 'da' and val1Copy != 'dos' and val1Copy != 'das'):
                            break
                        else:
                            location += ' ' + val1


            # PRICE, SCORE AND ITS LIMITS
            if(tag == 'NUM'):
                if(i+1 < len(tags) and tags[i + 1][0].lower()[:4] == 'euro'):
                    price = float(valCopy)
                    limitPrice = 0
                    euroWord = 1
                    check = 1
                elif(i+1 < len(tags) and tags[i + 1][0].lower()[:6] == 'estrel'):
                    score = float(valCopy)
                    limitScore = 0
                    starWord = 1
                    check = 1

                j = 1
                while (j <= i):
                    if (euroWord == 0 and tags[i-j][0][:5] =='preco' or tags[i-j][0][:5] =='preço' or tags[i-j][0][:7] =='quantia' or tags[i-j][0][:4] =='cust'):
                        price = float(valCopy)
                        check = 1
                        break
                    elif(starWord == 0 and tags[i-j][0][:5] =='score' or tags[i-j][0][:5] =='cotaç' or tags[i-j][0][:5] =='cotac' or tags[i-j][0][:7] =='rating' or tags[i-j][0][:7] =='ranking'):
                        score = float(valCopy)
                        check = 1
                        break
                    elif((tags[i-j][0] =='menos' and tags[i-j-1][0] =='pelo' ) or tags[i-j][0][:6] =='minimo' or tags[i-j][0][:6] =='mínimo' or tags[i-j][0][:8] =='superior' or tags[i-j][0][:8] =='maior' or (tags[i-j][0][:4] =='mais' and (tags[i-j+1][0] =='de' or tags[i-j+1][0] =='que'))):
                        typeLimit = 1
                        if(starWord == 1 or euroWord == 1):
                            break
                    elif (tags[i - j][0][:6] == 'máximo' or tags[i - j][0][:6] == 'maximo' or tags[i - j][0] == 'menos' or tags[i - j][0] == 'inferior'):
                        typeLimit = -1
                        if (starWord == 1 or euroWord == 1):
                            break
                    j += 1

                if (score != -1 and typeLimit == 1):
                    limitScore = 1
                elif (score != -1 and typeLimit == -1):
                    limitScore = -1
                elif (price != -1 and typeLimit == 1):
                    limitPrice = 1
                elif (price != -1 and typeLimit == -1):
                    limitPrice = -1

                if (check != 1):
                    typeLimit = 0



            # ORDER AND TYPE OF THE SORT
            elif (valCopy == 'caro'):
                order = 'desc'
                sort = 'cost'
            elif (valCopy == 'barato'):
                order = 'asc'
                sort = 'cost'
            elif (valCopy == 'melhor' and i+1 < len(tags) and (tags[i+1][0][:10] == 'restaurant' or tags[i+1][0][:5] == 'comid' and tags[i+1][0][:6] == 'refeic' or tags[i+1][0][:6] == 'refeiç' or tags[i+1][0][:5] == 'sitio' or tags[i+1][0][:5] == 'sítio' or tags[i+1][0][:5] == 'local' or tags[i+1][0][:11] == 'estabelecim')):
                order = 'desc'
                sort = 'rating'
            elif (valCopy == 'pior' and i + 1 < len(tags) and (tags[i + 1][0][:10] == 'restaurant' or tags[i + 1][0][:5] == 'comid' or tags[i + 1][0][:6] == 'refeic' or tags[i + 1][0][:6] == 'refeiç' or tags[i + 1][0][:5] == 'sitio' or tags[i + 1][0][:5] == 'sítio' or tags[i + 1][0][:5] == 'local' or tags[i + 1][0][:11] == 'estabelecim')):
                order = 'asc'
                sort = 'rating'
            elif (valCopy == 'barato'):
                order = 'asc'
                sort = 'cost'

            if (valCopy == 'mais' and tags[i + 1][0][:5] == 'baixo'):
                order = 'asc'
                if(tags[i - 1][0][:5] == 'preco' or tags[i - 1][0][:5] == 'preço'):
                    sort = 'cost'
                elif(tags[i - 1][0][:5] =='score' or tags[i - 1][0][:5] =='cotaç' or tags[i - 1][0][:5] =='cotac' or tags[i - 1][0][:7] =='rating' or tags[i - 1][0][:7] =='ranking'):
                    sort = 'rating'
            elif (valCopy == 'mais' and tags[i + 1][0][:5] == 'alto'):
                order = 'desc'
                if(tags[i - 1][0][:5] == 'preco' or tags[i - 1][0][:5] == 'preço'):
                    sort = 'cost'
                elif(tags[i - 1][0][:5] =='score' or tags[i - 1][0][:5] =='cotaç' or tags[i - 1][0][:5] =='cotac' or tags[i - 1][0][:7] =='rating' or tags[i - 1][0][:7] =='ranking'):
                    sort = 'rating'



            # TYPE OF REQUEST
            elif (valCopy == 'rua' or valCopy == 'endereço' or valCopy == 'morada' or valCopy[:9] == 'localizaç' or valCopy[:9] == 'localizac'):
                typeRequest = 'address'
                if(i+2 < len(tags) and (tags[i + 1][0] == 'do' or tags[i + 1][0] == 'da' or tags[i + 1][0] == 'de') and tags[i + 2][1] == 'NOUNP'):
                    restaurantName = tags[i + 2][0]
                    if (i + 3 < len(tags)):
                        for j, (val1, tag1) in enumerate(tags[i + 3:]):
                            val1Copy = val1.lower()
                            if (val1Copy != '-' and tag1 != 'NOUNP' and val1Copy != 'de' and val1Copy != 'do' and val1Copy != 'da' and val1Copy != 'dos' and val1Copy != 'das'):
                                break
                            else:
                                restaurantName += ' ' + val1

            elif (valCopy[:8] == 'contacto' or valCopy[:7] == 'contato' or valCopy[:7] =='telefon' or valCopy[:5] == 'telem'):
                typeRequest = 'contact'
                if(i+2 < len(tags) and (tags[i + 1][0] == 'do' or tags[i + 1][0] == 'da' or tags[i + 1][0] == 'de') and tags[i + 2][1] == 'NOUNP'):
                    restaurantName = tags[i + 2][0]
                    if (i + 3 < len(tags)):
                        for j, (val1, tag1) in enumerate(tags[i + 3:]):
                            val1Copy = val1.lower()
                            if (val1Copy != '-' and tag1 != 'NOUNP' and val1Copy != 'de' and val1Copy != 'do' and val1Copy != 'da' and val1Copy != 'dos' and val1Copy != 'das'):
                                break
                            else:
                                restaurantName += ' ' + val1


            # TYPE OF ESTABLISHMENT
            elif (valCopy[:5] == 'almoç' or valCopy[:5] == 'almoc'):
                category = 'Lunch'
            elif (valCopy[:4] == 'jant'):
                category = 'Dinner'
            elif (valCopy[:4] == 'cafe' or valCopy[:4] == 'café'):
                category = 'Cafes'
            elif (valCopy[:6] == 'bebida'):
                category = 'Cafes'

            # TYPE OF CUISINE
            elif ((valCopy[:10] == 'restaurant' or valCopy[:6] == 'comida' or valCopy[:5] == 'refei') and i+1 < len(tags) and (tags[i + 1][1] == 'NOUNP' or tags[i + 1][1] == 'ADJ')):
                typeCuisine = tags[i + 1][0]


        print('LOCATION: ' + location)
        print('TYPEREQUEST: ' + typeRequest)
        print('SCORE: ' + str(score))
        print('SCORELIMIT: ' + str(limitScore))
        print('PRICE: ' + str(price))
        print('PRICELIMIT: ' + str(limitPrice))
        print('TYPECUISINE: ' + typeCuisine)
        print('SORT: ' + sort)
        print('ORDER: ' + order)
        print('CATEGORY: ' + category)
        print('RESTAURANTENAME: ' + restaurantName)


        ZomatoLogicAdapter.answer = zomato_api.Zomato.search(zomatoApi, typeRequest, category, typeCuisine, location, location, price, limitPrice, score, limitScore, sort, order, restaurantName, self.key,self.url)

        return 1, Statement('')



def select_response(statement, statement_list):
    if (ZomatoLogicAdapter.answer != ''):
        return Statement(ZomatoLogicAdapter.answer)
    else:
        return statement_list[0]