import OrderedMap "mo:base/OrderedMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

persistent actor ContactManager {
  transient let natMap = OrderedMap.Make<Nat>(Nat.compare);

  type Contact = {
    id : Nat;
    name : Text;
    email : Text;
    phone : Text;
    notes : ?Text;
  };

  var contacts : OrderedMap.Map<Nat, Contact> = natMap.empty<Contact>();
  var nextId : Nat = 1;

  

  public func addContact(name : Text, email : Text, phone : Text, notes : ?Text) : async Nat {
    validateContact(name, email, phone);

    let id = nextId;
    let contact = {
      id;
      name;
      email;
      phone;
    };

    contacts := natMap.put<Contact>(contacts, id, contact);
    nextId += 1;
    id;
  };

  public func getAllContacts() : async [Contact] {
    Iter.toArray(natMap.vals(contacts));
  };

  public func getContact(id : Nat) : async ?Contact {
    natMap.get(contacts, id);
  };

  public func updateContact(id : Nat, name : Text, email : Text, phone : Text, notes : ?Text) : async () {
    validateContact(name, email, phone);

    switch (natMap.get(contacts, id)) {
      case (null) { Debug.trap("Contact not found") };
      case (?_) {
        let updatedContact : Contact = {
          id;
          name;
          email;
          phone;
          notes;
        };
        contacts := natMap.put(contacts, id, updatedContact);
      };
    };
  };

  public func deleteContact(id : Nat) : async () {
    switch (natMap.get(contacts, id)) {
      case (null) { Debug.trap("Contact not found") };
      case (?_) {
        contacts := natMap.delete(contacts, id);
      };
    };
  };

  func validateContact(name : Text, email : Text, phone : Text) : () {
    if (Text.size(name) == 0) {
      Debug.trap("Name is required");
    };
    if (Text.size(email) == 0) {
      Debug.trap("Email is required");
    };
    if (Text.size(phone) == 0) {
      Debug.trap("Phone number is required");
    };
  };
};