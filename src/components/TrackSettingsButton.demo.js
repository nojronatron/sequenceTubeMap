import Demo, {props as P} from 'react-demo'
// See https://github.com/rpominov/react-demo for how to make a demo

import TrackSettingsButton from "./TrackSettingsButton.js";

export default (<Demo
    props={{
      fileType: P.choices(["haplotype", "graph", "read"]),
      trackColorSettings: P.json({    
        mainPallete: "blues",
        auxPallete: "reds",
        colorReadsByMappingQuality: false}),
      availableColors: P.json(["greys", "ygreys", "blues", "reds", "plainColors"])
    }}
  >
    {
      (props, update) => {
        return <TrackSettingsButton {...props} setTrackColorSetting={(key, value) => {
          // modify a key in TrackColorSettings
          let newTrackColorSettings = {...props.trackColorSettings};
          newTrackColorSettings[key] = value;
          update({trackColorSettings: newTrackColorSettings})
        }}/>
      }
    }
  </Demo>)
  
