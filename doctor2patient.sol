
//pragma  solidity ^0.4.2;

library Set {
  struct IndexValue { uint keyIndex; uint value; }
  struct KeyFlag { uint key; bool deleted; }
  struct KeyValue { uint key; uint value; }
  
  struct Data { 
      mapping(uint => IndexValue) data;
      KeyFlag[] keys;
      //KeyValue[] kvpairs;
      uint size;
  }

  function insert(Data storage self, uint key, uint value) returns (bool replaced){
    uint keyIndex = self.data[key].keyIndex;
    self.data[key].value = value;
    if (keyIndex > 0)
      return true;
    else
    {
      keyIndex = self.keys.length++;
      self.data[key].keyIndex = keyIndex + 1;
      self.keys[keyIndex].key = key;
      self.size++;
      return false;
    }
  }
  
  function remove(Data storage self, uint key) returns (bool success){
        uint keyIndex = self.data[key].keyIndex;
        if (keyIndex == 0)
          return false;
        delete self.data[key];
        self.keys[keyIndex - 1].deleted = true;
        self.size --;
  }
  
  function contains(Data storage self, uint key) returns(bool){
    return self.data[key].keyIndex > 0;
  }
  
  function iterate_start(Data storage self) returns (uint keyIndex){
    return iterate_next(self, uint(-1));
  }
  
  function iterate_valid(Data storage self, uint keyIndex) returns (bool){
    return keyIndex < self.keys.length;
  }
  
  function iterate_next(Data storage self, uint keyIndex) returns (uint r_keyIndex){
    keyIndex++;
    while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
      keyIndex++;
    return keyIndex;
  }
  
  function iterate_get(Data storage self, uint key) returns (uint, uint){
    //r.key = self.keys[keyIndex].key;
    //r.key = self.data[key].keyIndex;
    //r.value = self.data[key].value;
    return (self.data[key].keyIndex,self.data[key].value);
  }
  
}

contract patientRecord {
    bytes32 public patientName;
    bytes32 public patientPolicy;
    
    using Set for Set.Data;
    Set.Data e;
    
    function insert(uint k, uint v) returns (uint size)
      {
        e.insert(k, v);
        return e.size;
      }
      
      function contains(uint c) returns (bool)
      {
          if (e.contains(c)) {
              return true;
          }
          return false;
      }
      
      function get_item(uint k) returns(uint,uint){
          return e.iterate_get(k);
      }
      
      function get_next_index(uint n) returns (uint)
      {
          return e.iterate_next(n);
      }
    
    function spatientRecord(bytes32 pName, bytes32 pPolicy) {
        patientName = sha3(pName);
        patientPolicy = sha3(pPolicy);
    }
    
    function patient() returns(bytes32){
        return patientName;
    }
    
    function reg_doctor(bytes32 doctor_name, bool perm, address addr) {
        //add code to take in doctors information and insert into linked list
    }
    
    function search_doctor_perm(bytes32 name) returns(bool) {
        //add code to search through structs for checking doctor's assigned permission
    }
    
    function ret_patient_details() returns(bytes32 p_name, bytes32 p_address){
        //add code to retrieve patient details
    }
}

contract doctorAccess {

    function getPatient(address patient_contract) returns (bytes32){
        patientRecord pr = patientRecord(patient_contract);
        return pr.patient();
    }

    function bytes32ToString(bytes32 x) constant returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[charCount] = char;
            charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}



