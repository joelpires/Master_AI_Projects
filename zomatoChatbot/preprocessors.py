# -*- coding: utf-8 -*-

def clean_whitespace(chatbot, statement):
    import re
    if statement.text[len(statement.text)-1] in ['?', '.', '!']:
        statement.text = statement.text[:-1]

    statement.text = statement.text.replace('\n', ' ').replace('\r', ' ').replace('\t', ' ')
    statement.text = statement.text.strip()
    statement.text = re.sub(' +', ' ', statement.text)
    return statement


def convert_to_ascii(chatbot, statement):
    import unicodedata
    import sys

    if sys.version_info[0] < 3:
        statement.text = unicode(statement.text)

    text = unicodedata.normalize('NFKD', statement.text)
    text = text.encode('ascii', 'ignore').decode('utf-8')

    statement.text = str(text)
    return statement

 #frame based chatbot; agents ou preencher dps no nltk para extrair tipo de proposiçoes , nomes proprios
        #representacao semantica; similaridade de palavras (se nao estier restaurante na frase mas sim cafe/sittio ele faz a mesma coisa (spacy ou word embedding 2vector - neighbors)
        # Diz me um restaurante Italiano para jantar no Chiado
def translate(chatbot, statement):
    dic_cuisines = {'africano': 'African', 'americano': 'American', 'angolano': 'Angolan', 'asiatico': 'Asian', 'asiático': 'Asian',
                    'padaria': 'Bakery', 'brasileiro': 'Brazilian', 'ingles': 'British', 'inglês': 'British', 'hamburgueria': 'Burger', 'chinês': 'Chinese',
                    'chines': 'Chinese', 'sobremesas': 'Desserts', 'frances': 'French',
                    'saudavel': 'Healthy Food', 'saudável': 'Healthy Food', 'gelados': 'Ice Cream', 'indiano': 'Indian', 'italiano': 'Italian',
                    'madeirense': 'Madeiran', 'portugues': 'Portuguese', 'português': 'Portuguese', 'salada': 'Salad', 'espanhol': 'Spanish',
                    'vegetariano': 'Vegetarian', 'garrafeira': 'Wine Bar', 'pastelaria': 'Pastry Shop', 'quiosque': 'Kiosk',
                     'gelataria': 'Ice Cream Shop', 'casa de chá': 'Tea Room'}
    dic_numbers = {'um' : '1', 'dois':'2','três':'3','quatro':'4','cinco':'5','seis':'6','sete':'7',
                    'oito':'8','nove':'9','dez':'10','onze':'11','doze':'12','treze':'13','quatorze':'14','quinze':'15',
                    'dezasseis':'16','dezassete':'17','dezoito':'18','dezanove':'19','vinte':'20'}

    stat = statement.text.split(" ")


    #CUISINES
    for i in range(len(stat)):
        for j in dic_cuisines:
            if (stat[i].lower()[:5] == j[:5]):
                stat[i] = dic_cuisines[j]
                break

    #NUMBERS
    for i in range(len(stat)):
        for j in dic_numbers:
            if (stat[i] == j):
                stat[i] = dic_numbers[j]
                break

    statement.text = " ".join(stat)

    return statement
