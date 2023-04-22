import React, { useState } from 'react';
import { NativeModules, View, TouchableOpacity, Text } from 'react-native';
const { ARViewManager } = NativeModules;

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
    ARViewManager.startARView();
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