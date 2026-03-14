#set page(margin: 1.25cm)
#set text(size: 10pt, hyphenate: false)
#set par(leading: 0.6em, justify: true)
#set list(indent: 1em)

#show heading.where(level: 1): it => pad(
    bottom: 0.15em,
)[
    #text(upper(it.body), size: 1.5em)
]

#show heading.where(level: 2): it => block(
    width: 100%,
    stroke: (bottom: 1pt + black),
    inset: (bottom: 0.45em),
)[
    #upper(it.body)
]

#let format-date(date) = toml(bytes("date = " + date)).date.display("[month repr:short] [year]")

#let format-date-range(start, end) = [
    #format-date(start)
    #sym.dash.en
    #if end == none { "Present" } else { format-date(end) }
]

#let format-subtitle(subtitle, date) = box[
    #grid(
        columns: (2fr, 1fr),
        align: (left, right),
        subtitle, date,
    )
]

#let data = yaml("resume.yaml")

#align(center)[
    #set par(spacing: 0.8em)

    = #data.personal.name

    *#data.personal.titles.join("  /  ")*

    #data.personal.location

    #(
        link("mailto:" + data.personal.email),
        link("tel:" + data.personal.phone),
        ..data.personal.profiles.map(profile => {
            link(profile)[
                #profile.replace(regex("https?://(www\.)?"), "")
            ]
        }),
    ).join([#sym.space.en #sym.diamond.filled #sym.space.en])
]

== Work Experience

#for work in data.work {
    block[
        #set par(spacing: 0.6em)

        #block(sticky: true)[
            *#if "url" in work { link(work.url, work.organisation) } else { work.organisation } #h(1fr) #work.location*
        ]

        #block[
            #set par(spacing: 1.2em)

            #for position in work.positions {
                block(breakable: false)[
                    #format-subtitle(
                        [_#(position.position)_],
                        format-date-range(
                            position.start-date,
                            position.at("end-date", default: none),
                        ),
                    )
                    #for highlight in position.at("highlights", default: ()) [
                        - #eval(highlight, mode: "markup")
                    ]
                ]
            }
        ]
    ]
}

== Education

#for education in data.education {
    block(breakable: false)[
        #set par(spacing: 0.6em)

        *#if "url" in education { link(education.url, education.institution) } else { education.institution } #h(1fr) #education.location*

        #format-subtitle(
            [_#(education.degree)_],
            format-date-range(
                education.start-date,
                education.at("end-date", default: none),
            ),
        )

        #list(
            [*Honours:* #education.honours.join(", ")],
            [*Focus Areas:* #education.focus-areas.join(", ")],
            ..education.at("highlights", default: ()).map(highlight => eval(highlight, mode: "markup")),
        )
    ]
}

== Extracurricular Activities

#for activity in data.activities {
    block(breakable: false)[
        #set par(spacing: 0.6em)

        *#if "url" in activity { link(activity.url, activity.organisation) } else { activity.organisation } #h(1fr) #activity.location*

        #format-subtitle(
            [_#(activity.position)_],
            format-date-range(
                activity.start-date,
                activity.at("end-date", default: none),
            ),
        )

        #for highlight in activity.at("highlights", default: ()) [
            - #eval(highlight, mode: "markup")
        ]
    ]
}

== Honours and Awards

#for award in data.awards {
    block(breakable: false)[
        #set par(spacing: 0.6em)

        *#if "url" in award { link(award.url, award.title) } else { award.title } #h(1fr) #award.location*

        #format-subtitle(
            [Issued by _#(award.issuer)_],
            format-date(award.date),
        )

        #for highlight in award.at("highlights", default: ()) [
            - #eval(highlight, mode: "markup")
        ]
    ]
}

