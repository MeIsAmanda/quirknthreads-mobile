# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`
import stripe

from firebase_functions import https_fn
from firebase_admin import initialize_app

# put this is secret manager
STRIPE_SECRET_KEY = 'sk_test_51P1ThsDAIh3MeY43fEX45h9oPoc7Bv3IzI9stNPXFQKxP2wl3jX7gMaz36R0Nz1XFa4rzBEOiF7UrRgURnRctcuW00NUXIH4e0'
app = initialize_app()

@https_fn.on_request()
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

    total = 1400

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
            intent = stripe.PaymentIntent.create(api_key=STRIPE_SECRET_KEY, **params)
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