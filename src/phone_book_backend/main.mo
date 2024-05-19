import Trie "mo:base/Trie";
import Text "mo:base/Text";
import Nat32 "mo:base/Nat32";
import Bool "mo:base/Bool";
import Option "mo:base/Option";

actor {

    type ContactId = Nat32;
    type Contact = {
        name: Text;
        phone: Text;
        email: Text;
        isFavorite: Bool;
        isBlocked: Bool;
    };

   private stable var next : ContactId = 0;

   private stable var contacts : Trie.Trie<ContactId, Contact> = Trie.empty();

   public func addContact(contact : Contact) : async Text {
    if (not validatePhoneNumber(contact.phone)) {
            return ("Phone number must be a 10-digit");
        };
    let contactId = next;
    next += 1;
    contacts := Trie.replace(
      contacts,
      key(contactId),
      Nat32.equal,
      ?contact,
    ).0;
    return ("Contact Created Successfully");
  };

   public func delete(contactId : ContactId) : async Bool {
    let result = Trie.find(contacts, key(contactId), Nat32.equal);
    let exists = Option.isSome(result);
    if (exists) {
      contacts := Trie.replace(
        contacts,
        key(contactId),
        Nat32.equal,
        null,
      ).0;
    };
    return exists;
  };

  public func getContactByName(searchKey: Text) : async Trie.Trie<ContactId, Contact> {

  let filteredContact: Trie.Trie<ContactId, Contact> = Trie.filter<ContactId, Contact>(contacts, func (key: ContactId, contact: Contact)  { contact.name == searchKey});

      return filteredContact;
  };

  public func deleteByName(name : Text) : async Text {
        var result : ?ContactId = null;

        let iter = Trie.iter(contacts);
        for ((id, superhero) in iter) {
            if (superhero.name == name) {
                result := ?id;
            };
        };

        return ("s");

    };


  private func key(x : ContactId) : Trie.Key<ContactId> {
    return { hash = x; key = x };
  };


  private func validatePhoneNumber(phone: Text) : Bool {
        if (phone.size() != 10) {
            return false;
        };
        return true;
    };

   
}