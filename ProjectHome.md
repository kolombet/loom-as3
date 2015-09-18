# Loom: An AOP Library and Bytecode Weaver for ActionScript 3 #
_[Loom lives on as as3commons-bytecode!](http://www.maximporges.com/2010/06/27/loom-becomes-as3commons-bytecode/) Please support Roland and his team as they pick up the torch._

The goal of the Loom project was to provide runtime subclass generation and bytecode weaving in a native ActionScript 3 environment. The primary intent for the library was to support aspect-oriented programming (AOP), but further use cases include supporting mocking, logging, security, and other AOP-based solutions that need to overcome the limitations of the new fixed traits model in the ActionScript 3 language.

An alpha release was in progress and was released to Google Code in 2009. [Learn more here](http://maximporges.com/2009/01/aop-advice-for-actionscript-3-and-flex.html).

## Project Updates ##
~~Sadly, Loom is dead. I just ran out of time and motivation to get 'er done. I recommend the excellent [FLoxy](http://code.google.com/p/floxy/) and [FLemit](http://code.google.com/p/flemit) libraries by Richard Szalay as alternatives, and all the mocking work done by Richard in [ASMock](http://asmock.sourceforge.net/) and Drew Bourne in [mock-as3](http://code.google.com/p/mock-as3/) and [mockolate](http://github.com/drewbourne/mockolate).~~

[Loom is now as3commons-bytecode.](http://www.maximporges.com/2010/06/27/loom-becomes-as3commons-bytecode/)

For historical purposes, you can read the development history of this library on the [Loom blog](http://loom.ninjitsoft.com/). I'm also leaving the source out here as a reference for people who want to hack the AVM; I spent a ton of time learning how it worked and trying to make its internals simple for me, so hopefully others will find the parsers and bytecode emitters useful.

## Contact Me ##
I can be reached via [the contact form on the Loom blog](http://loom.ninjitsoft.com/?page_id=38).