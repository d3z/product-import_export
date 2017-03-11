# Product Importer / Exporter

I just thought I'd set out the reasons behind some of the choices I made in my solution to this problem.

First of all, take a look at `integration_test/manual_test.rb` (no, it's not really an integration test) to
see how I wanted the code to be called. 

This is all probably non-idiomatic Ruby. I was aiming for non-idiotic Ruby.

*It's very likely that I missed some of what was being asked for implicitly in the wording of the problem. I'm old and last
winter took the last of the sight from my one good eye. I have 10 kids to feed and a wood chip burner that won't keep itself
going on fuel. It's been a tough winter. Go easy.*

It was clear from the start that the importer and exporter had to be separated. The problem stated that there *may* be 
other formats in the future (sounds like it was written by a BA). Therefore, an intermediary was required,
hence, the `Product` class. Importers would accept strings (more on that in a second) and produce a list of `Product`s.
Exporters would take a list of `Product`s and produce a string (I've written this readme before writing the code, 
Documentation Driven Development, so the exporters may actually be writing directly to file and I've forgotten to come
back and change the readme).

I chose to use a `ProductBuilder` because I'm a Java developer at heart and builders are in my blood. I would have added more
levels of abstraction had I been able to find my copy of the Gang Of Four (it might have ended up in the burner). That, and 
it makes testing a lot easier. I hate classes with big lists of constructor arguments. "Why not just use properties on the class then?" 
you might ask, and I'll ignore you, because it's late, and the burner needs more wood chips and because ...

The first module I found (I'm a Ruby newb ... a Rewbie ... a Nuby ...) was the CSV module and it supports reading csv from
file. Sounded good, except, as we know, reading from files makes testing a royal PITA. So, as with most instances like this, 
I decided that the importer and exporters would deal with strings as much as possible, making the testing of them *a lot* 
easier.

Once the importers were importing and the exporters were ... exporting, I cobbled together the `ProductDataTransposer` class
that wired it all together (again, I wrote this before that so, it's very likely got a different name). Simply register the 
importers and exporters with it, and it should (it does ... it probably does) find the right importer and exporter for the 
filenames you pass it (Strategy, FTW!).

## Fairly Asinine Queries

**It doesn't look like you have done Ruby for a while. Why did you choose to do this probelm in Ruby?**

I thought I'd give it a go and see how it went. Having said that, I once teased a Mexican wrestler about
his silly costume, to see how that went. My history of doing things to see how they go shows it to be, 
perhaps, a less than stellar life strategy.

**Did you spend most of this time learning enough Ruby to do the challenge?**

No.

...

Yes.

**You've mentioned _Bulider_ and _Strategy_ more than once in this README. Are you a pattern junkie?**

No. That was a, perhaps misguided, trick to see if ShopKeep have filters in their process that catch and remove serial enterprise developers. Kind of a reverse SEO.

**Do you really have one of those wood burners that everyone is talking about recently?**

All official records say no.