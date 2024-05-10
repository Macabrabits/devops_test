import type {Config} from 'jest';

const config: Config = {
  verbose: true,
  moduleFileExtensions: [
    "js",
    "json",
    "ts"
  ],
  rootDir: "src",
  testRegex: ".*\\.spec\\.ts$",
  transform: {
    "^.+\\.(t|j)s$": "ts-jest"
  },
  collectCoverageFrom: [
    "**/*controller.(t|j)s",
    "**/*service.(t|j)s"
  ],
  coverageDirectory: "../coverage",
  testEnvironment: "node",
  coverageThreshold: {
    global: {
      branches: 50,
      functions: 50,
      lines: 50
    },
  },
};

export default config;