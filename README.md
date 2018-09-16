# BySykkel Playground

## Prerequisites 
- [Xcode or Xcode beta](https://developer.apple.com/download/) or from AppStore.
- `git clone git@github.com:Torsph/BySykkel.git`
- `cd BySykkel`
- `open BySykkel.playground` or `open BySykkel/BySykkel.xcodeproj`

## How to run
### Playground
After opening the playground it should be as easy as clicking the little play button, but it usually just play it self automagically.
You may need to open the assistent editor (cmd + option + enter) to show the live view.

### Project with tests
There is no way to run tests from playground today so there repo containts a project that could run both unit test and ui tests.
- `CMD + R` will run the app
- `CMD + U` will run the unit test and UI test.

## Structure
### Playground
`BySykkel.playground` is where the code is runned from. To make it work you need to supply your token inside the `token` variable.
It initializes a `BySykkelAPI`, that is injected into the `BySykkelViewModel` and further injected into the `BySykkelViewController`.
The `BySykkelViewController` will act as the liveView that is presented in the playground.

Most of the source code is under the `Source` folder and will be automatically compiled by Xcode. So nothing special is need to be done.

### Project
The project is mostly the same as the playground, but there is some extra files since we need to it as an app. (`AppDelegate etc`)
It also includes a new `BySykkelMapViewController` that shares the `BySykkelViewModel` with the `BySykkelViewController`. The reason for this is to
share the data between both viewControllers instead of loading the data twice. It switches the `BySykkelViewModel.delegate` to the viewController that is displayed.

Two test folders, `BySykkelTests` and `BySykkelUITests`, has been added to test the code. Im currently mocking the network calls in the unit test with some easy
homemade mocking tool. It basically subclasses the `URLSession` and returns the provided result instead of going to the network.

Currently the UITests goes to the internet because its no good way to mock requests when you don't have access to the source code because of how 
UITests are done Xcode/Simulator. There is tools and ways to make it possible, but it will require to much work for a small assignment like this.

## General information
If you are not that familiar with swift and its syntax the code that uses `$0 $1` etc in `BySykkelModel.swift` may look abit weird.
But its nothing more then a shorthand syntax for argument names. Where `$0` is the first argument, `$1` the second, etc.

## Futher work
The current network solution is pretty easy with no parallel loading of the request. I wanted to add [Operation](https://developer.apple.com/documentation/foundation/operation) and [OperationQueues](https://developer.apple.com/documentation/foundation/operationqueue) that  would make it possible to set up two operations that could run i paralell and then have one operation depending those two operations. The reason for not adding this is the boilerplate you need to add. In a bigger project it would make sense, but here it would just make the code harder to read/understand if you don't know how apple's operation code works.

