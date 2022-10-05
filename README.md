### Overview

The main goal of this project is to create a simple Pokedex app with basic functions such as searching pokemons by name and generation, and see their  details (types, abilities, stats...) in another screen, so that the user has the possibility to navigate between the search Screen and the Detail screen.

### Roadmap

For that, I have thought in a path like this one to cover the creation of the entire application:

THE FIST MOCKUP

1) [x] Choose a correct API to retrieve pokémon data (DONE: https://pokeapi.co, probably the most used pokemon API)
2) [x] Create a simple screen to retrieve data from API and print it as a grid table
3) [x] Create a simple detail screen to navigate between the main screen (pokemon list) and this one (pokemon detail)
4) [x]Mockup done! Now, start applying good practises as good as posible: naming conventions, OOP, repository pattern, follow MVVM architecture to manage data correctly...

THE SEARCH SCREEN

![image](https://user-images.githubusercontent.com/49367885/194107673-5f177ad7-9b53-4354-bffd-875584480fd0.png)

Now, it is convenient to follow a design similar to this one (pokemon battle box): a box full of pokémons to navigate between, with a simple but attractive UI.

To create a box like this one, I could follow a path like this one...

1) [ ] Replicate the UI in a simple way, dividing it into components: the upper "BOX" toolbar, the table grid showing the pokemons, the background and the bottom buttons. For now, I will add this buttons: a search button, a team button and a OK button, just to give more options to the user. At the end of everything we will polish the design to make it as attractive as possible.

2) [ ] From a technical side, create a repository class to retrieve the data from API in a cleaner way.

3) [ ] Also see what kind of objects will be necessary to retrieve from the API

4) [ ] Create the Viewmodel for the screen, to use it as a bridge between the view and the data, and try to choose a good naming convention for variables and functions.
