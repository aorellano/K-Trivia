//
//  FirebaseReference.swift
//  KTrivia
//
//  Created by Alexis Orellano on 4/12/22.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case questions
    case groups
    case game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
