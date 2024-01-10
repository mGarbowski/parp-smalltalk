Object subclass: ItemFactory [
    ItemFactory class >> lockerRoomKey [
        |lrk|
        lrk := Interactable
            name: 'locker room key'
            description: 'heavy metal key, what does it open?'
            hint: 'use it to open the locked door'.
        ^lrk
    ]
]