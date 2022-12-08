<img width="250px" src="https://user-images.githubusercontent.com/49367885/202322769-654e653c-25a5-4aef-9ca7-5287aac79aa3.png"> <img width="250px" src="https://user-images.githubusercontent.com/49367885/202322787-c2eaa318-c6bb-41ee-b090-4f83ae367166.png"> <img width="250px" src="https://user-images.githubusercontent.com/49367885/202323542-ca32a72a-70e9-4f8f-a7f9-546ff0413607.png">


## SwiftUI Pokédex

The main goal of this project is to reinforce basic concepts about iOS development and have fun developing with SwiftUI (Apple’s latest framework for iOS development).

SwiftUI is a powerful framework which provides an easy and intuitive way to create user interfaces via coding instead of the classic drag and drop builder seen in Android with xml and previously in iOS with Storyboards; this goal is achieved thanks a mix between code and view provided by the declarative programming paradigm that accompanies SwiftUI.

In this repository I have created a kind of “Pokédex” application whose main purpose is to show a list of all existing pokémons and some interesting information about them such as their typings, abilities or moves.

So I coded this app because I like the Pokémon franchise and, also, because it is a good way to take a look at PokeApi API, one of the biggest Pokémon databases right now.
 
Let’s take a look at it.

## Database

[PokéAPI](https://pokeapi.co/) is a RESTful API which has a huge quantity of data related to Pokémon videogames (it is mainly focused in this media), and consequently, it provides us a way to access some interesting data such as pokemons’ sprites, abilities or stats, among others.

Its endpoints have a good amount of information stored in JSON format, and it is also supported with good documentation, which is appreciated.

It is also interesting to mention that it is an open source project created in 2014 and updated generation after generation. Therefore, you can also contribute to make it a bigger and even more reliable source :)

## Architecture

This application was made with Model-View-ViewModel architecture because it is easy to apply, it has a lot of benefits, and has a good synergy with SwiftUI’s state based way to change views.

To summarize, MVVM is a strategy used to separate our applications in three layers: Model (data and how to get it), View (user interface) and ViewModel (the connector between data and views).

This way we achieve a separation of responsibilities which provides multiple advantages such as an organized way to struct our project, an easier way to read our code, a decouplement of our code and a strategy to make it more testable, which can be translated into a easier to maintain and more robust project.

![1_SWQ5UQ1XU8wSykwXnWpiNg](https://user-images.githubusercontent.com/49367885/202320477-681c7c14-9bdb-4cae-8d22-2b54c65bff73.png)

## Libraries

Nowadays iOS SDK has enough tools to achieve our goals in an easy way, thanks to libraries like UserDefaults to store local data via key-value strategy (recommended if we are storing small amounts of data), or URLSession to make API calls from different threads (background to prevent locking user’s UI, and main to print our data into views).

## Some strategies used in this project

- Repository Pattern

It is a good way to obtain reusability from our repository via a global class which provides us access to the different services offered from our datasource. It also helps us with code decoupling in the Model layer (which can be translated into an easier way to maintain this layer).

A good way to implement this strategy is to create an interface which will give us flexibility to access our data, because it provides us the possibility to mock data for testing, or change the API without making a huge impact on our project.

Now our project looks like this:

![1_5kNXJ7aFSGJvuh4r4egpTg](https://user-images.githubusercontent.com/49367885/202320651-79982d45-2991-4869-80fb-43f55d854e86.png)

- Singleton Pattern

A design pattern used to get access to objects among the project without the necessity to instantiate them each time.

It gives us more accessibility, better memory management and less code to write.

- Observer Pattern

A design pattern related with SwiftUI’s programming nature and the reactivity from libraries like RxSwift.

Its goal is to use observers to observe variables (data) in a M:1 relation, where observers can observe datasource’s changes without being directly linked with the observed variables, providing flexibility (you can change observables and it won't affect to the observed data) and helping mobile architectures in view-controller decoupling.

- Dependency Injection Pattern

This technique helps us with objects instantiation, reducing the boilerplate from class instances; in consequence, it reduces time by adding the required objects to our classes automatically, after a simple setup from our injector. 
It is also a good tool to test our classes, and this pattern contributes to the Dependency Inversion principle.

- SOLID principles

SOLID principles are key concepts to apply good practices in our projects, making them more easy to maintain and improving their scalability.

Some of the principles applied in this project:
  - Single Responsibility (S): This principle is tightly tied to our project’s architecture, since its goal is to separate our project in layers which have their own responsibility, making our code better structured and easier to maintain.
  - Dependency Inversion (D): We apply this principle when we use the Repository interface to access our datasource; this interface gives us flexibility when we need to get data from external resources, since it provides us what we want to get, but not how to get it. 
  It is also reinforced by using Depency Injection principle along the project.

If you want to learn more about SOLID principles, [check this article](https://www.baeldung.com/solid-principles) or [watch this video](https://youtu.be/t8VTLxMsufU)

