const Localize = require("./Localize.js/Localize");
const { keysFileTemplate, localizableFileTemplate } = require("./templates");
const en = require("./locales/en");

const DEFAULT_LOCALE = "en";

const locales = { en };

const packageName = "PGLocale";

const main = () => {
  const localize = new Localize(
    `Packages/${packageName}/Sources/${packageName}/Resources`,
    `Packages/${packageName}/Sources/${packageName}/Keys.swift`,
    locales,
    DEFAULT_LOCALE,
    2
  );
  localize.setKeysTemplate(keysFileTemplate(packageName));
  localize.setLocaleFileTemplate(localizableFileTemplate);
  localize.generateFiles().then(console.log("Done localizing"));
};

main();
