interface ITask {
	run<T>(src: T):T;
}

/* Export It
 ************/
export default ITask