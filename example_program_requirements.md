`The purpose of this document is to lay down what each example program using the library in each language should do.`

*Note*: We will include a server which we will use for each programing language example. It will be reachable @ `http://localhost:3344`

For the purpose of this example, we will build an tiny section of a order confirmation frontend.
The program should read and parse a list of the orders provided inside `examle_orders.txt` then place them into an array/list.
When looping over this list/array, if the order failed its payment, fire a event you created for this speffic case.
This event should then send a messsage to the server, asking for confirmation that the payment did indeed fail. The server will then send a response back. The response will be a JSON object.

Example program:
```ts
class EventLocal {
    private action: Function | null;
    
    constructor() {
        //...
        this.action = null;
    }

    addAction(onTrigger: Function) {
        //...
        this.action = onTrigger;
    }

    trigger(...args: unknown[]) {
        //...
        if (this.action === null) return;
        this.action(...args);
    }
}


class Events {
    constructor() {
        //...
    }

    newEvent() {
        //...
        return new EventLocal();
    }
    //...
}

const events = new Events();
const payment_failed_event = events.newEvent();
const payment_failed_incorrect = events.newEvent();

const orders = [
    {
        order_number: 24244,
        payment_failed: false
    },
    {
        order_number: 24245,
        payment_failed: true
    }
]

payment_failed_event.addAction(async (order_number: number) => {
    const request = await fetch('http://localhost:3344', {
        method: 'POST',
        body: JSON.stringify({
            'order_number': order_number
        }),
    });

    if (!request.ok) return;

    const response = await request.json();

    if (response.payment_failed) return;

    payment_failed_incorrect.trigger(order_number);
});

payment_failed_incorrect.addAction((order_number: number) => {
    const order_index = orders.findIndex((order) => order.order_number === order_number);

    if (order_index > -1) {
        orders[order_index].payment_failed = false;
    }
})

for (const order of orders) {
    if (order.payment_failed) {
        payment_failed_event.trigger(order.order_number);
    }
}
```
Or I might write some tests, I'll see.
