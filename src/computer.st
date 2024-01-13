Object subclass: Computer [

    Computer class >> runComputer [
        | input |
        "Main computer input loop"
        [ true ] whileTrue: [
            Transcript show: '/home/sysy$ '.
            input := FileStream stdin nextLine.
            (input isEmpty) ifTrue: [ ^ self ]. "Exit conditions"

            (input = 'exit' or: [input = 'quit' or: [input = 'shutdown']]) ifTrue: [
                Transcript show: 'Shutting down...'; nl.
                ^ self.
            ].

            self processCommandInput: input.
        ].
    ]

    Computer class >> processCommandInput: input [
        "Process user input, supports a few basic commands + sudo mode"

        | validCommand |
        validCommand := false.  "Initialize the flag as false"

        input = 'ls' ifTrue: [
            Transcript show: ''; nl; flush.
            validCommand := true.
        ].

        input = 'ls -la' ifTrue: [
            Transcript show: '-r-------- 1 root root 123 Nov 11 12:34 .pass'; nl.
            validCommand := true.
        ].

        input = 'ls -a' ifTrue: [
            Transcript show: '.pass'; nl.
            validCommand := true.
        ].

        (input startsWith: 'cd ') ifTrue: [
            Transcript show: 'Cannot cd to ', (input copyFrom: 4); nl.
            validCommand := true.
        ].

        (input startsWith: 'cat ') ifTrue: [
            (input = 'cat .pass') ifTrue: [
                Transcript show: 'Permission denied'; nl.
            ] ifFalse: [
                Transcript show: 'cat: ', (input copyFrom: 5), ': No such file or directory'; nl.
            ].
            validCommand := true.
        ].

        (input startsWith: 'sudo ') ifTrue: [
            self passwordLoop: (input copyFrom: 6).
            validCommand := true.
        ].

        input = 'clear' ifTrue: [
            Transcript show: (Character value: 27) asString, '[2J'. "ANSI escape code to clear the terminal"
            validCommand := true.
        ].

        validCommand ifFalse: [
            Transcript show: 'Unknown command: ', input; nl.
        ].

        ^ self.  "Return self at the end"
    ]

    Computer class >> passwordLoop: input [
        "Loop asking for a password when something is run with sudo"
        | pass |

        Transcript show: '[sudo] password for sysy:'; nl.
        pass := FileStream stdin nextLine.
        pass isEmpty ifTrue: [ ^ self ]. "exit the loop if empty password is provided"

        "Correct password entered"
        pass = 'KirgisWalter' ifTrue: [
            (input = 'cat .pass') ifTrue: [
                Transcript show: 'security code: 852611'; nl.
                ^ self
            ] ifFalse: [
                self processCommandInput: input. 
            ]
        ] ifFalse: [
            Transcript show: 'Invalid password.'; nl.
            self passwordLoop: input.
        ]
    ]
]

Computer runComputer.
