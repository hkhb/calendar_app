export interface Schedule{
  name: string;
  start_time: Date | string;
  finish_time: Date | string;
  days ?: number;
  event?: string;
}