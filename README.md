# BySykkel Playground

## Prerequisites 
- [Xcode or Xcode beta](https://developer.apple.com/download/) or from AppStore.
- `git clone <some git url>`
- `cd repo/BySykkel.playground`

## How to run
After opening the playground it should be as easy as clicking the little play button.
You may need to open the assistent editor (cmd + option + enter) to show the live view.

## Structure
`BySykkel.playground` is where the code is runned from. To make it work you need to supply your token inside the `token` variable.
It initializes a `BySykkelAPI`, that is injected into the `BySykkelViewModel` and further injected into the `BySykkelViewController`.
The `BySykkelViewController` will act as the liveView that is presented in the playground.

Most of the source code is under the `Source` folder and will be automatically compiled by Xcode. So nothing special is need to be done.

## General information
If you are not that familiar with swift and its syntax the code that uses `$0 $1` etc in `BySykkelModel.swift` may look abit weird.
But its nothing more then a shorthand syntax for argument names. Where `$0` is the first argument, `$1` the second, etc.

## Futher work
The current network solution is pretty easy with no parallel loading of the request. I wanted to add [Operation](https://developer.apple.com/documentation/foundation/operation) and [OperationQueues](https://developer.apple.com/documentation/foundation/operationqueue) that  would make it possible to set up two operations that could run i paralell and then have one operation depending those two operations. The reason for not adding this is the boilerplate you need to add. In a bigger project it would make sense, but here it would just make the code harder to read/understand if you don't know how apple's 
operation code works.

