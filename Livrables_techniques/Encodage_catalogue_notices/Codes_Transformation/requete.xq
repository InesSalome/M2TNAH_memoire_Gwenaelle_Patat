declare default element namespace "http://www.tei-c.org/ns/1.0";

let $tout := doc("reprise/tout.xml")
let $rubricDoc := doc("reprise/rubric.xml")
return 
  for $msItem in $tout//msItem[@corresp]
  let $corresp := $msItem/@corresp/string()
  return 
    for $rubric in $rubricDoc//msItem[@corresp/string()=$corresp]//rubric
      return 
        insert node $rubric
        as last into $msItem