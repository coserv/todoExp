This TODO list sample application is to showcase how easy a web app can be built using the [coServ](https://github.com/benlue/coServ) web server. You can show a TODO list, and click on any one of them to see the details. You can even modify a TODO item.

## Get started
You can clone the project or use npm to install the project:

    npm install @coserv/todoExp

This project has already embedded a coServ server. Once installed, you can go to the install directory and type the following in the command line to start the web application:

    npm start

Point your browser to http://127.0.0.1:8080/todo/list to see it work.

## Explaining the code
You can go the the _www/todoExp/assets/themes/default/palets/todo_ directory to look for the major source files:

* list.xs: This is the main file. It will load the todo list and display it. It also listens to the click event on any TODO item and invokes a dialog to show the details info of the selected item. If users modify a TODO item, this palet will call _/todo/updateItem_ to save the update.

* view.xs: This palet will display the detailed information of a TODO item.

* updateItem.xs: This is a "faceless" palet. That is it will not render any view for display. Instead, it accepts input and use the input data to update a TODO item.

Besides the three palets mentioned above, you may also want to check the _www/todoExp/lib/TodoModel.js_ file. That is a node.js module which works as the data model for this example app.