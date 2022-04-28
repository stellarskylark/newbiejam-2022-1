I don't think we've met before. #green

* Hello. #player 
-> continue
* Uh...who are you? #player
-> continue
* [Say nothing.] -> nothing

=== nothing ===
You say nothing, and continue listening to the stranger.
-> continue

=== nothing2 ===
You say nothing, just staring blankly at the stranger instead. 
-> continue2

=== continue ===
I'm one of the many friendly facets you'll meet around around these parts. Nice to meet you. #green

And yes, I did mean to say facets rather than faces. It seemed more fitting. #green

I'm looking forward to talking to you more. I've always liked to meet new people. Or so I'm told. #green

* [What is that supposed to mean?] What do you mean, "so you're told?" #player
-> explain
* Nice to meet you too.#green 
-> finish 
* [Say nothing.] -> nothing2
=== continue2 ===
{nothing: You're not really much for conversation, are you?}  #green
{not nothing: ... Anyways.} #green


{nothing && nothing2: I'll leave you alone. You seem...busy. } #green
    ->END
-> finish
 
=== explain ===
Well, it doesn't really matter. 
I'm new to this, forgive me. It was a figure of speech, I suppose. 
-> finish

=== finish===
- Thanks for sticking around and talking for a bit. Hope you'll come have another chat soon.

-> END