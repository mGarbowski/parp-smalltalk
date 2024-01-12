Object subclass: Computer [

    Computer class >> runComputer [
        | input |
        "Main computer input loop"
        [ true ] whileTrue: [
            Transcript show: '/home/sysy$ '.
            input := FileStream stdin nextLine.
            (input isEmpty) ifTrue: [ ^ self ]. "Exit conditions"

            (input = 'exit' or: input = 'quit' or: input = 'shutdown') ifTrue: [
                Transcript show: 'Shutting down...'; nl.
                ^ self.
            ].
            self processCommandInput: input.
        ].
    ]

    Computer class >> processCommandInput: input [
        "Process user input, supports a few basic commands + sudo mode"
        input = 'ls' ifTrue: [ Transcript show: ''; nl; flush. ^ self ].
        input = 'ls -la' ifTrue: [
            Transcript show: '-r-------- 1 root root 123 Nov 11 12:34 .pass'; nl.
            ^ self
        ].
        input = 'ls -a' ifTrue: [
            Transcript show: '.pass'; nl.
            ^ self
        ].
        (input startsWith: 'cd ') ifTrue: [
            Transcript show: 'Cannot cd to ', (input copyFrom: 4); nl.
            ^ self
        ].
        (input = 'cat .pass') ifTrue: [
            Transcript show: 'Permission denied'; nl.
        ].
        (input startsWith: 'cat ') ifTrue: [
            Transcript show: 'cat: ', (input copyFrom: 5), ': No such file or directory'; nl.
            ^ self
        ].
        (input startsWith: 'sudo ') ifTrue: [ self passwordLoop: (input copyFrom: 6) ].
        input = 'clear' ifTrue: [
            Transcript show: (Character value: 27) asString, '[2J'. "ANSI escape code to clear the terminal"
            ^ self
        ].
        Transcript show: 'Unknown command: ', input; nl.
    ]

    Computer class >> passwordLoop: input [
        "Loop asking for a password when something is run with sudo"
        | pass |
        pass := FileStream stdin nextLine.
        pass isEmpty ifTrue: [ ^ self ].
        pass = 'KirgisWalter' ifTrue: [
            Transcript show: 'security code: 852611'; nl.
            ^ self
        ].
        Transcript show: 'Invalid password.'; nl.
        self passwordLoop: input.
    ]

]

Computer runComputer.
