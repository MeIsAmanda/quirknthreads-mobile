# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`
import stripe

import google.cloud.firestore

from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore
from firebase_functions.params import SecretParam

# put this is secret manager
STRIPE_SECRET_KEY = SecretParam("STRIPE_SECRET_KEY")
app = initialize_app()

@https_fn.on_request(secrets=[STRIPE_SECRET_KEY])
def stripe_pay_endpoint_method_id(req: https_fn.Request) -> https_fn.Response:
    print(req.method, req.get_json()) #this prints in the server logs

    if req.method != "POST":
        return https_fn.Response(status=403, response="Forbidden") #cannot use GET requests

    data = req.get_json() #keep them in a map
    payment_method_id = data.get('paymentMethodId') #identify which is the payment id
    items = data.get('items')
    currency = data.get('currency')
    use_stripe_sdk = data.get('useStripeSdk')

    #calculate the total in the server side

    total = _calculate_order_amount(items)

    try:
        if payment_method_id:
            params = {
                'payment_method': payment_method_id,
                'amount': total,
                'currency': currency,
                'confirm': True,
                'use_stripe_sdk': use_stripe_sdk,
                'automatic_payment_methods': {
                    'enabled': True,
                    'allow_redirects': 'never',
                }
            }
            intent = stripe.PaymentIntent.create(api_key=STRIPE_SECRET_KEY.value, **params)
            return _generate_response(intent)
            #return https_fn.Response(status=200, response=intent)

        else:
            return https_fn.Response(status=400, response="Bad request") #no payment id = error

    except Exception as e:
        return https_fn.Response(status=500, response=str(e))



def _generate_response(intent):
    if intent.status == "requires_action":
        return{
            "clientSecret": intent.client_secret,
            "requiresAction": True,
            "status": intent.status,
        }
    elif intent.status == "requires_payment_method":
        return {"error": "Your card was denied, please provide a new payment method"}
    elif intent.status == "succeeded":
        print("Payment received!")
        return{"clientSecret": intent.client_secret, "status": intent.status}
    else:
        return {"error": "Failed"}

def _calculate_order_amount(items):
    total_cost = 0

    firestore_client = google.cloud.firestore.Client = firestore.client()
    products_documents = firestore_client.collection('products').get()

    for doc in products_documents:
        doc_data = doc.to_dict()
        product_id = doc.id

        for item in items:
            if item['product'].get('id') == product_id:
                quantity = item['quantity']
                price = doc_data.get('price', 0)
                total_cost += quantity * price

    return int(total_cost * 100)