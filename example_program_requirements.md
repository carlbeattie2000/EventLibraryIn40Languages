`The purpose of this document is to lay down what each library's base functionality should be and what each example program using the library in each language should do.`

For the purpose of this example, we will build an tiny section of a order confirmation frontend.
The program should read and parse a list of the orders provided inside `example_orders.txt` then place them into an array/list.
When looping over this list/array, if the order failed its payment, fire a event you created for this speffic case.
This event should then send a messsage to the server, asking for confirmation that the payment did indeed fail. The server will then send a response back. The response will be a JSON object.

Each library should have the following:
- Event Creation and Emission: Provide a mechanism to create new events and trigger them when necessary.
- Event Storage and Invocation: Enable users to store events in variables, allowing for independent invocation of events without the emitter.
- Event Removal: Offer an option to remove events.
- Standardized Event Messages: Implement a standardized format.
- Event Queue (Optional): Provide an event queue to support asynchronous event handling, ordering, prioritization, concurrency management, and backpressure handling.

Example Program:
This was going to be a order system, but I have a idea for a little game that I will write for each language,
It will be fun and I'll learn so much more.
