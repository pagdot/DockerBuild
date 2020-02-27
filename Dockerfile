FROM chocolateyfest/chocolatey AS build

RUN choco install golang make git
