## Circular imports

In the 1D tic-tac-toe game for your homework, you probably wrote several modules.
Maybe it looks like this:
(The arrows between show that a module is being imported.)

```plain
┌──────────────────╮  ┌───────────────╮  ┌──────────────────╮ 
│      ai.py       │  │ tictactoe.py  │  │    game.py       │
├──────────────────┤  ├───────────────┤  ├──────────────────┤
│                  │->│ import ai     │->│ import tictactoe │
├──────────────────┤  ├───────────────┤  ├──────────────────┤
│ def ai_move      │  │ def evaluate  │  │                  │
│                  │  │ def move      │  │                  │
└──────────────────┘  │def player_move│  └──────────────────┘
                      │               │
                      └───────────────┘
                          │
                          │              ┌───────────────────╮
                          │              │ test_tictactoe.py │
                          │              ├───────────────────┤
                          └─────────────>│ import tictactoe  │
                                         ├───────────────────┤
                                         │ def test_...      │
                                         │                   │
                                         └───────────────────┘
```

But the function `ai_move` needs to call the function `move`.<br>
What can we do?<br>
Could you import `ai` from `tictactoe` while you are also importing `tictactoe` from `ai`?


```plain
┌──────────────────╮  ┌───────────────╮
│      ai.py       │  │ ticktacktoe.py│
├──────────────────┤  ├───────────────┤
│                  │◀-│ import ai     │
│import ticktaktoe │-▶│               │
│                  │  │               │
│   def ai_move    │  │ def evaluate  │
│                  │  │ def move      │
└──────────────────┘  │def player_move│
                      │               │
                      └───────────────┘  
```
Let's look at it from the point of view of Python executing the commands.
When it imports `ticktackto.py`, it reads the file line by line.
Near the beginning, it sees the command `import ai`.
So it opens the file `ai.py` and it starts reading it line by line.
And of course it soon gets to `import ticktacktoe`. What next?

To avoid an infinite loop - one file imports another, which imports the first one 
again, over and over - Python will resort to a workaround when we run `tictactoe`:
When it notices that `tictactoe` is already being imported into `ai.py`,
it will import the part of `tictactoe` that precedes `import ai` into the `ai` module,
and this part replaces the line `import tictactoe` so it's no longer there. 
And then it continues the import of `ai` in `tictactoe.py`.
When it finishes this import, it continues in `tictactoe` and all its functions and commands.

This workaround can be useful in avoiding infinite loops, but most of the time 
it behaves unpredictably, therefore it's dangerous.

In other words: When two modules are trying to import each other, 
the program may not work as expected.

We want to prevent this kind of situation.

How? We have two options.


## Organise modules by dependency

Our first option is to move the function `move` to the module `ai`, and use it from there.
This would be an easy solution, but that's not what we want from the `ai` module; it should contain
only the logic how our "AI" chooses where to move.
It definitely shouldn't contain other functions which might be useful somewhere else.


```plain
┌──────────────────╮  ┌───────────────╮
│      ai.py       │  │  tictactoe.py │
├──────────────────┤  ├───────────────┤
│                  │->│ import ai     │
│                  │  │               │
│ def ai_move      │  │ def evaluate  │
│ def move         │  │def player_move│
│                  │  │               │
└──────────────────┘  └───────────────┘
```

## Support module

Our second option is to define a new separate module which will be used in
`tictactoe.py` and in `ai.py`.

Developers usually name such a support module `util.py` (from "utility").

```plain
              ┌──────────────────╮
              │ util.py          │
              ├──────────────────┤
              │ def move         │
              └──────────────────┘
                      │  │
┌──────────────────╮ │  │   ┌───────────────╮
│      ai.py       │  │  │  │  tictactoe.py │
├──────────────────┤  │  │  ├───────────────┤
│ import util      │<─┘  └─>│ import util   │
│                  │───────>│ import ai     │
│                  │        │               │
│ def ai.move      │        │ def evaluate  │
│                  │        │def player_move│
│                  │        │               │
└──────────────────┘        └───────────────┘
```

One disadvantage of a support module is that it can easily 
turn into an unmaintainable code storage that you have used in so
many places that you no longer have any idea where exactly you used it, 
and whether you can modify or delete it.

Which option you should choose always depends on the current situation.
