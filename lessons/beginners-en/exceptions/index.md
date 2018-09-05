# Exceptions

We were already talking about [error messages]({{ lesson_url('beginners/print') }}) : 
Python complains, tells us where is the error (line) and terminates the program.
But there are lot more what we can learn about error messages (a.k.a *exceptions*).


## Printing errors:

In the beginning we will repeat how Python prints error which is in nested function.


```python
def out_func():
    return in_func(0)

def in_func(divisor):
    return 1 / divisor

print(out_func())
```

<!-- XXX: Highlight the line numbers -->

```pycon
Traceback (most recent call last):          
  File "/tmp/example.py", line 7, in <module>
    print(out_func())
  File "/tmp/example.py", line 2, in out_func
    return in_func(0)
  File "/tmp/example.py", line 5, in in_func
    return 1 / divisor
ZeroDivisionError: division by zero
```

You can notice that every function calling that led to error is written there.
The actuall error is probably somewhere around that function calling.
In our case it's easy. We should't call `in_func` with argument `0`.
Or this `in_function` should be prepared that the divisor can be `0`
and it should do something else than try to devide by zero.

Python can't know where is the error that should repaired so it shows
you everything in error message.
It will be very useful in more difficult programs.


## Raising rror

Error or more precisely *exception* could be also invoked by command `raise`.
After that command there have to be the name of the exception and then you write some 
information about what went wrong into brackets.


```python
LIST_SIZE = 20

def verify_number(number):
    if 0 <= number < LIST_SIZE:
        print('OK!')
    else:
        raise ValueError('The number {n} is not in the list!'.format(n=number))
```

All types of built-in exceptions are
[here](https://docs.python.org/3/library/exceptions.html) including their hierarchy.

Those are important to us now:

```plain
BaseException
 ├── SystemExit                     raised by function exit()
 ├── KeyboardInterrupt              raised after pressind Ctrl+C
 ╰── Exception
      ├── ArithmeticError
      │    ╰── ZeroDivisionError    zero division
      ├── AssertionError            command `assert` failed
      ├── AttributeError            non-existing attribute, e.g. 'abc'.len
      ├── ImportError               failed import
      ├── LookupError
      │    ╰── IndexError           non-existing index, e.g. 'abc'[999]
      ├── NameError                 used non-existing name of variable
      │    ╰── UnboundLocalError    used variable, which wasn't initiated
      ├── SyntaxError               wrong syntax – program is unreadable/unusable
      │    ╰── IndentationError     wrong indentation
      │         ╰── TabError        combination of tabs and spaces
      ├── TypeError                 wrong type, e.g. len(9)
      ╰── ValueError                wrong value, e.g. int('xyz')
```


## Handling Exceptions

And why are there so many?
So you can cath them! :)
In the following function the `int` function can 
fail when there is something else than
number given to it. So it needs to be prepared for
that kind of situation.

```python
def load_number():
    answer = input('Enter some number: ')
    try:
        number = int(answer)
    except ValueError:
        print('That wasn\'t a number! I will continue with 0')
        number = 0
    return number
```

How does that work?

Jak to funguje?
Příkazy v bloku uvozeném příkazem `try` se normálně provádějí, ale když
nastane uvedená výjimka, Python místo ukončení programu provede
všechno v bloku `except`.
Když výjimka nenastane, blok `except` se přeskočí.

Když odchytáváš obecnou výjimku,
chytnou se i všechny podřízené typy výjimek –
například `except ArithmeticError:` zachytí i `ZeroDivisionError`.
A `except Exception:` zachytí všechny
výjimky, které běžně chceš zachytit.


## Nechytej je všechny!

Většinu chyb ale není potřeba ošetřovat.

Nastane-li nečekaná situace, je téměř vždy
*mnohem* lepší program ukončit, než se snažit
pokračovat dál počítat se špatnými hodnotami.
Navíc chybový výstup, který Python standardně
připraví, může hodně ulehčit hledání chyby.

„Ošetřování” chyb jako `KeyboardInterrupt`
je ještě horší: může způsobit, že program nepůjde
ukončit, když bude potřeba.

Příkaz `try/except` proto používej
jen v situacích, kdy výjimku očekáváš – víš přesně, která chyba může
nastat a proč, a máš možnost ji opravit.
Pro nás to typicky bude načítání vstupu od uživatele.
Po špatném pokusu o zadání je dobré se ptát znovu, dokud uživatel nezadá
něco smysluplného:

```python
def nacti_cislo():
    while True:
        odpoved = input('Zadej číslo: ')
        try:
            return int(odpoved)
        except ValueError:
            print('To nebylo číslo! Zkus to znovu.')
```


## Další přílohy k `try`

Kromě `except` existují dva jiné bloky,
které můžeš „přilepit“ k `try`, a to `else` a `finally`.
První se provede, když v `try` bloku
žádná chyba nenastane; druhý se provede vždy – ať
už chyba nastala nebo ne.

Můžeš taky použít více bloků `except`. Provede se vždy maximálně jeden:
ten první, který danou chybu umí ošetřit.

```python
try:
    neco_udelej()
except ValueError:
    print('Tohle se provede, pokud nastane ValueError')
except NameError:
    print('Tohle se provede, pokud nastane NameError')
except Exception:
    print('Tohle se provede, pokud nastane jiná chyba')
    # (kromě SystemExit a KeyboardInterrupt, ty chytat nechceme)
except TypeError:
    print('Tohle se neprovede nikdy')
    # ("except Exception" výše ošetřuje i TypeError; sem se Python nedostane)
else:
    print('Tohle se provede, pokud chyba nenastane')
finally:
    print('Tohle se provede vždycky; i pokud v `try` bloku byl např. `return`')
```


## Úkol

Doplň do geometrické kalkulačky (nebo 1-D piškvorek, máš-li je) ošetření chyby,
která nastane když uživatel nezadá číslo.

{% filter solution %}

Možné řešení pro geometrickou kalkulačku:

```python

while True:
    try:
        strana = float(input('Zadej stranu čtverce v centimetrech: '))
    except ValueError:
        print('To nebylo číslo!')
    else:
        if strana <= 0:
            print('To nedává smysl!')
        else:
            break

print('Obvod čtverce se stranou', strana, 'je', 4 * strana, 'cm')
print('Obsah čtverce se stranou', strana, 'je', strana * strana, 'cm2')

```

Možné řešení pro 1-D piškvorky:

```python
def nacti_cislo(pole):
    while True:
        try:
            pozice = int(input('Kam chceš hrát? (0..19) '))
        except ValueError:
            print('To není číslo!')
        else:
            if pozice < 0 or pozice >= len(pole):
                print('Nemůžeš hrát venku z pole!')
            elif pole[pozice] != '-':
                print('Tam není volno!')
            else:
                break

    pole = pole[:pozice] + 'o' + pole[pozice + 1:]
    return pole


print(tah_hrace('-x----'))
```
{% endfilter %}
