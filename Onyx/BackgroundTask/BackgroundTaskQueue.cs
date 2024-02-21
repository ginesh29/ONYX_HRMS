using System.Collections.Concurrent;

namespace Onyx.BackgroundTask
{
    public interface IBackgroundTaskQueue
    {
        void QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem);
        Task<Func<CancellationToken, Task>> DequeueAsync(CancellationToken cancellationToken);
    }
    public class BackgroundTaskQueue : IBackgroundTaskQueue
    {
        private readonly ConcurrentQueue<Func<CancellationToken, Task>> _workItems;
        private readonly SemaphoreSlim _signal;
        public BackgroundTaskQueue()
        {
            _workItems = new ConcurrentQueue<Func<CancellationToken, Task>>();
            _signal = new SemaphoreSlim(0);
        }
        public void QueueBackgroundWorkItem(Func<CancellationToken, Task> workItem)
        {
            _workItems.Enqueue(workItem);
            _signal.Release();
        }
        public async Task<Func<CancellationToken, Task>> DequeueAsync(CancellationToken cancellationToken)
        {
            await _signal.WaitAsync(cancellationToken);
            _workItems.TryDequeue(out var workItem);
            return workItem;
        }
    }
}