const keysFileTemplate = (packageName) => (input) => {
  return `//
//  Keys.swift
//
//
//  Created by Kamaal M Farah on 05/09/2021.
//

extension ${packageName} {
    public enum Keys: String {
${input}
    }
}
`;
};

const localizableFileTemplate = (input) => {
  return `/*
  Localizable.strings

  Created by Kamaal M Farah on 05/09/2021.

*/

${input}
`;
};

module.exports = { keysFileTemplate, localizableFileTemplate };
