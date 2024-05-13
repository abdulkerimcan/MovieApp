# Movie App
A simple iOS app that shows movies in different categories, allows searching and practically applies the combine library.

## Features

- Add Watch List
- Search Movies
- Movie Details

## Technologies and Libraries

- **UIKit:** Used for building the user interface.
- **MVVM Architecture:** The app follows the Model-View-ViewModel (MVVM) design pattern.
- **Protocol-Oriented Programming:** Flexible design achieved through protocol-oriented programming.
- **Combine:** A framework in the Swift language and is an example of functional reactive programming (FRP). It was used to manage asynchronous data streams and handle events
- **Image Caching:** Image caching allows images downloaded over the network to be stored locally and reused later.

## Overview


Combine is a framework by Apple for Reactive Programming in Swift, a programming language. Reactive Programming is based on the concept of data flow and event-driven programming, making it easier for applications to interact with data and respond to changes in state.
Combine provides a powerful model for managing data flow through publishers and subscribers. In this model, publishers represent the data flow and subscribers represent the components that react to the data emitted by publishers. Publishers can emit events such as values, errors, and completion, and deliver these events to subscribers.

<img width="818" alt="image" src="https://github.com/abdulkerimcan/MovieApp/assets/79968953/60d77dfb-de6a-494e-a53d-5de0620f4800">


In Combine, the concepts of input and output play an important role. Input represents the data sent from the view controller to the view model, while output represents the data sent from the view model to the view controller. This data flow is facilitated through methods like bind() and transform().

The bind() method connects the output publisher of the view model to UI components, enabling automatic updates of these components. On the other hand, the transform() method allows the view controller to forward input to the view model, enabling the view model to react to these inputs.

## Screenshot

https://github.com/abdulkerimcan/MovieApp/assets/79968953/5cc7384c-f367-429e-9ef1-97d87ca21ac0

