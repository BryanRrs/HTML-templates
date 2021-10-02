# html-template-generator
Dynamically generate html files from a template and context
Based in [Django's template system](https://docs.djangoproject.com/en/3.2/topics/templates/)

## How to use it
It works given a html template and a context hash.
Inside a html file you can define the next instructions:
1. **Variables:** Defined inside the template by two curly braces and spaces before and after the variable {{ var }}. Variables can be hashes/objects so they can be accessed as {{ object.field }}

**Example:**
Given the context 
```ruby
    context = {
        'User' => {
            'name' => 'John'
        }
    }
```
You can define the HTML
```html
    <div>
        {{ User.name }}
    </div>        
```
And it will print
```html
    <div>
        John
    </div> 
```

2. **For Blocks:** Defined by a instruction tag as {% for element in object %} and it must be end by a {% endfor %}.

**Example:**

Given the context
```ruby
    context = {
        'books' => [
            {'title' => 'Homo Deus',
             'author' => 'Yuval Noah Harari'},
            {'title' => 'The Picture of Dorian Gray',
             'author' => 'Oscar Wilde'},
        ]
    }
```

You can define the HTML
```html
    {% for book in books %}
    <div>
        {{ book.title }}
    </div>
    <div>
        {{ book.author }}
    </div>
    {% endfor %}
```
And it will print
```html
    <div>
        Homo Deus
    </div>
    <div>
        Yuval Noah Harari
    </div>
    <div>
        The Picture of Dorian Gray
    </div>
    <div>
        Oscar Wilde
    </div>
```

3. **If-Else Blocks:** Just as the **For Blocks**, it is defined by {% if condition %}, an optional {% else %} and a {% endif %}. The condition can be the existence of something (by giving only the name of the variable), or simple boolean conditions (if var1 cond var2).

    - Available conditions: <, <=, >, => and ==
    - You can also use values as: true, false, numbers and strings (with a slash before the literal: /exampleString )

**Example:**

Given the context
```ruby
    context = {
        'books' => [
            {'title' => 'Homo Deus',
             'author' => 'Yuval Noah Harari'},
            {'title' => 'The Picture of Dorian Gray',
             'author' => 'Oscar Wilde'},
        ],
        'owner' => {
            'name' => 'Bryan'
        }
    }
```

You can define the HTML
```html
    {% if true %}
        <div>
            True block
        </div>
    {% endif %}

    {% if stores %}
        <div>
            True block
        </div>
    {% else %}
        <div>
            False Block
        </div>
    {% endif %}

    {% if owner.name == /Bryan %}
        <div>
            He is a Cool Guy!
        </div>
    {% else %}
        <div>
            Don't know him
        </div>
    {% endif% }

```
And it will print
```html
        <div>
            True block
        </div>

        <div>
            False Block
        </div>

        <div>
            He is a Cool Guy!
        </div>
```

4. **Mixed Blocks**: You can also mix all the above

Example:

```ruby
    context = {
        'books' => [
            {'title' => 'Homo Deus',
             'author' => 'Yuval Noah Harari',
             'ownedBy' => 'John'},
            {'title' => 'The Picture of Dorian Gray',
             'author' => 'Oscar Wilde',
             'ownedBy' => 'Bryan'},
        ],
    }
```

You can define the HTML
```html
    {% for book in books %}
        {% if book.ownedBy == /Bryan %}
            <div>
                {{ book.title }} by {{ book.author }} owned by a cool guy
            </div>
        {% else %}
            <div>
                {{ book.title }} by {{ book.author }} owned by {{ book.ownedBy }}
            </div>
        {% endif% }
    {% endfor %}
```
And it will print
```html
        <div>
            Homo Deus by Yuval Noah Harari owned by John
        </div>
        <div>
            The Picture of Dorian Gray by Oscar Wilde owned by a cool guy
        </div>
```

## Warning

This is just a personal project intended to learn a little ruby and as a little challenge to myself