interface IBuildTypes {
	readonly default:        string;
	readonly dev:            string;
	readonly devTest:        string;
	readonly devTestClient:  string;
	readonly devTestServer:  string;
	readonly prod:           string;
	readonly prodServer:     string;
	readonly prodTest:       string;
	readonly prodTestClient: string;
	readonly prodTestServer: string;
	readonly test:           string;
	readonly testClient:     string;
	readonly testServer:     string;
}

const TYPES: IBuildTypes = {
	default:        'default',
	dev:            'dev',
	devTest:        'dev:test',
	devTestClient:  'dev:test:client',
	devTestServer:  'dev:test:server',
	prod:           'prod',
	prodServer:     'prod:server',
	prodTest:       'prod:test',
	prodTestClient: 'prod:test:client',
	prodTestServer: 'prod:test:server',
	test:           'test',
	testClient:     'test:client',
	testServer:     'test:server'
}

const DEFAULT_BUILDS: string[] = [
	TYPES.default,
	TYPES.test,
	TYPES.testClient,
	TYPES.testServer
]

const DEV_BUILDS: string[] = [
	TYPES.dev,
	TYPES.devTest,
	TYPES.devTestClient,
	TYPES.devTestServer
]

const PROD_BUILDS: string[] = [
	TYPES.prod,
	TYPES.prodServer,
	TYPES.prodTest,
	TYPES.prodTestClient,
	TYPES.prodTestServer
]

const TEST_BUILDS: string[] = [
	TYPES.test,
	TYPES.testClient,
	TYPES.testServer,
	TYPES.devTest,
	TYPES.devTestClient,
	TYPES.devTestServer,
	TYPES.prodTest,
	TYPES.prodTestClient,
	TYPES.prodTestServer
]

/* Export It
 ************/
export default {
	types:   TYPES,
	default: DEFAULT_BUILDS,
	dev:     DEV_BUILDS,
	prod:    PROD_BUILDS,
	test:    TEST_BUILDS
};