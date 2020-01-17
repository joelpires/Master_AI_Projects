# coding=utf-8
from chatterbot import ChatBot
import zomato_adapter
from chatterbot.trainers import ChatterBotCorpusTrainer

chatbot = ChatBot(
    'Zomato Bot',
    storage_adapter='chatterbot.storage.SQLStorageAdapter',
    input_adapter='chatterbot.input.TerminalAdapter',
    output_adapter='chatterbot.output.TerminalAdapter',
    logic_adapters=[
        'zomato_adapter.ZomatoLogicAdapter',
        {
            'import_path': 'chatterbot.logic.BestMatch',
            "statement_comparison_function": "chatterbot.comparisons.levenshtein_distance",
            "response_selection_method": "zomato_adapter.select_response"
        }

    ],
    filters=[
        'chatterbot.filters.RepetitiveResponseFilter'
    ],
    database='./database.sqlite3',
    key='cf6b1cc6edc2010494a1ea0ab5f81d3b',
    url="https://developers.zomato.com/api/v2.1/",
    id_city='',
    preprocessors=[
        'preprocessors.clean_whitespace',
        'preprocessors.translate'
    ]

)
#chatbot.storage.drop()
#chatbot.set_trainer(ChatterBotCorpusTrainer)
#chatbot.train(
#    "chatterbot.corpus.portuguese"
#)


while True:
    try:
        response = chatbot.get_response(None)

    except(KeyboardInterrupt, EOFError, SystemExit):
        break
