/* 
Providers is a state management tool. It gives us several methods for state management.

State management is to tell in rough words is like every thing on the screen is a state and if we have changing states like animations or menu for an example in this app, this has to be managed properly. 

The Widgets shouldn't include the heavy lifting logic. Without provider package we had to do it all in the main.dart itself which is the root for all the widgets. Hence to make it leaner we take the help of provider package.

In providers we define all the backend working logic which has to be done in our app for example fetching the menu from our app-backend-server. 

With this by registering the providers in our main.dart file we can use them anywhere in our widget tree and trigger or use any logic inside them.
*/