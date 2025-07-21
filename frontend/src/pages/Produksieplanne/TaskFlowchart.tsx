import ReactFlow, {
  Background,
  Controls,
  MarkerType,
  Handle,
  Position,
} from "react-flow-renderer";

type Task = {
  task_number: string;
  description: string;
  completed: boolean;
  predecessors: string[];
};

// Custom node component
function TaskNode({ data }: any) {
  return (
    <div
      className="rounded px-2 py-1 border-2"
      style={{
        width: 180,
        border: "2px solid black",
        backgroundColor: data.completed
          ? "#1b8f3c" // hardcoded green for completed
          : "#f8fafc", // hardcoded blue/purple for incomplete
        color: data.completed ? "white" : "black",
      }}
    >
      {/* Left handles */}
      <Handle
        type="target"
        position={Position.Left}
        id="l1"
        style={{ top: 30 }}
      />
      <Handle
        type="target"
        position={Position.Left}
        id="l2"
        style={{ top: 10 }}
      />
      <Handle
        type="target"
        position={Position.Left}
        id="l3"
        style={{ top: 50 }}
      />
      {/* Right handles */}
      <Handle
        type="source"
        position={Position.Right}
        id="r1"
        style={{ top: 30 }}
      />
      <Handle
        type="source"
        position={Position.Right}
        id="r2"
        style={{ top: 10 }}
      />
      <Handle
        type="source"
        position={Position.Right}
        id="r3"
        style={{ top: 50 }}
      />

      <div className="font-bold">{data.task_number}</div>
      <div>{data.description}</div>
    </div>
  );
}

const nodeTypes = { taskNode: TaskNode };

function getDepth(task: Task, allTasks: Task[]): number {
  if (!task.predecessors || task.predecessors.length === 0) return 0;
  const predTasks = allTasks.filter((t) =>
    task.predecessors.includes(t.task_number)
  );
  if (predTasks.length === 0) return 1;
  return 1 + Math.max(...predTasks.map((t) => getDepth(t, allTasks)));
}

function getAlternatingY(index: number, gap: number): number {
  if (index === 0) return 0;
  const sign = index % 2 === 0 ? 1 : -1;
  const level = Math.ceil(index / 2);
  return sign * level * gap;
}

export default function TaskFlowchart({ tasks }: { tasks: Task[] }) {
  const taskDepthMap: Record<string, number> = {};
  const depthGroups: Record<number, Task[]> = {};

  for (const task of tasks) {
    const depth = getDepth(task, tasks);
    taskDepthMap[task.task_number] = depth;
    if (!depthGroups[depth]) depthGroups[depth] = [];
    depthGroups[depth].push(task);
  }

  const X_GAP = 240;
  const Y_GAP = 100;

  const nodes = tasks.map((task) => {
    const depth = taskDepthMap[task.task_number];
    const siblings = depthGroups[depth];
    const index = siblings.findIndex((t) => t.task_number === task.task_number);
    const y = getAlternatingY(index, Y_GAP);
    return {
      id: task.task_number,
      type: "taskNode",
      data: { ...task },
      position: {
        x: depth * X_GAP,
        y,
      },
    };
  });

  // Build outgoing map: pred -> [successors]
  const outgoingMap: Record<string, string[]> = {};
  tasks.forEach((task) => {
    task.predecessors.forEach((pred) => {
      if (!outgoingMap[pred]) outgoingMap[pred] = [];
      outgoingMap[pred].push(task.task_number);
    });
  });

  const edges: Array<{
    id: string;
    source: string;
    sourceHandle: string;
    target: string;
    targetHandle: string;
    type: string;
    markerEnd: { type: MarkerType };
    style: { stroke: string };
    animated: boolean;
  }> = [];

  for (const task of tasks) {
    task.predecessors.forEach((pred, predIndex) => {
      const outgoingIndex = outgoingMap[pred].indexOf(task.task_number);
      edges.push({
        id: `${pred}->${task.task_number}`,
        source: pred,
        sourceHandle: `r${(outgoingIndex % 3) + 1}`, // r1, r2, r3
        target: task.task_number,
        targetHandle: `l${(predIndex % 3) + 1}`, // l1, l2, l3
        type: "bezier",
        markerEnd: { type: MarkerType.ArrowClosed },
        style: { stroke: "black" },
        animated: false,
      });
    });
  }

  return (
    <div style={{ height: 500, width: "100%" }}>
      <ReactFlow nodes={nodes} edges={edges} nodeTypes={nodeTypes} fitView>
        <Background />
        <Controls />
      </ReactFlow>
    </div>
  );
}
