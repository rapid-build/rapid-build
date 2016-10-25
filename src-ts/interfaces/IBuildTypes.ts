/* BUILD TYPES INTERFACE
 ************************/
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

/* Export It
 ************/
export default IBuildTypes