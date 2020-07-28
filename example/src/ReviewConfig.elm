module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-example` will look for these.

To add packages that contain rules, add them to this example project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import Review.Rule exposing (Rule)
import NoMissingDocumentation


config : List Rule
config =
    [ NoMissingDocumentation.rule ]
