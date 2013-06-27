## go-test

The Golang testing tool I like.

![](https://dl.dropboxusercontent.com/s/vfdg8mu7vvjfkjx/testgo.png)

## Usage

```go
package main

import . "github.com/azer/go-test"

func main () {

  It("does almost nothing", func(expect Expect) {
    expect(3.14, 3.14)
    expect(156, 154)
  })

  It("does more than nothing", func(expect Expect) {
    expect("Yo!", 156)
  })

}
```

## Projects Using It

* [ansi-codes](http://github.com/azer/go-ansi-codes)

![](https://dl.dropboxusercontent.com/s/77k6n4vxjhgbauf/npmel_36.jpg)
