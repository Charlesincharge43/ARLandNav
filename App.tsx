import React, { useState } from 'react';
import { NativeModules, View, TouchableOpacity, Text } from 'react-native';
const { ARViewManager } = NativeModules;

console.log('and diz???  this is the big one!', ARViewManager)

const ARView = () => {
  return (
    <View style={{ flex: 1, backgroundColor: 'green' }}>
      <Text style={{ color: 'white', fontSize: 30 }}>AR view code goes here</Text>
    </View>
  );
};

const App = () => {
  const [showARView, setShowARView] = useState(false);

  // Switch to AR view
  const startARView = () => {
    ARViewManager.startARView([
      // 15th and Halsted address (the intersection where I take dog to the park)
      { isFake: false, checkpointText: "34", latitude: 41.861500, longitude: -87.64675, altitude: 183 },
      // 834 W 15th Place, Chicago address (neighbor to the East)
      { isFake: false, checkpointText: "33", latitude: 41.861149, longitude: -87.648018, altitude: 183 },
      // 838 W 15th Place, Chicago address
      { isFake: false, checkpointText: "32", latitude: 41.861150, longitude: -87.648160, altitude: 183 },
      // 840 W 15th Place, Chicago address (neighbor to the west)
      { isFake: false, checkpointText: "31", latitude: 41.861150, longitude: -87.648220, altitude: 183 },
      // South of my location
      { isFake: false, checkpointText: "00", latitude: 41.860974, longitude: -87.648138, altitude: 183 },
    ]);
    setShowARView(true);
  };

  // Switch back to React Native view
  const stopARView = () => {
    ARViewManager.stopARView();
    setShowARView(false);
  };

  return (
    <>
      {showARView ? (
        <View style={{ flex: 1 }}>
          <ARView />
          <TouchableOpacity onPress={stopARView} style={{ position: 'absolute', bottom: 20, left: 20 }}>
            <Text style={{ color: 'white', fontSize: 20 }}>Stop AR View</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
          <TouchableOpacity onPress={startARView}>
            <Text style={{ color: 'blue', fontSize: 30 }}>Start AR View</Text>
          </TouchableOpacity>
        </View>
      )}
    </>
  );
};

export default App;