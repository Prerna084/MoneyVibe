
import React from 'react';
import { 
  Radar, RadarChart, PolarGrid, PolarAngleAxis, PolarRadiusAxis, ResponsiveContainer 
} from 'recharts';
import { TraitCategory } from '../types';

interface TraitChartProps {
  scores: Record<TraitCategory, number>;
}

export const TraitChart: React.FC<TraitChartProps> = ({ scores }) => {
  const data = [
    { subject: 'Planning', A: scores[TraitCategory.PLANNING], fullMark: 5 },
    { subject: 'Impulse', A: scores[TraitCategory.IMPULSE], fullMark: 5 },
    { subject: 'Risk', A: scores[TraitCategory.RISK], fullMark: 5 },
    { subject: 'Calmness', A: scores[TraitCategory.CALMNESS], fullMark: 5 },
  ];

  return (
    <div className="w-full h-72 py-4">
      <ResponsiveContainer width="100%" height="100%">
        <RadarChart cx="50%" cy="50%" outerRadius="80%" data={data}>
          <PolarGrid stroke="#333" />
          <PolarAngleAxis dataKey="subject" tick={{ fill: '#888', fontSize: 12 }} />
          <PolarRadiusAxis angle={30} domain={[0, 5]} tick={false} axisLine={false} />
          <Radar
            name="Traits"
            dataKey="A"
            stroke="#D4AF37"
            fill="#D4AF37"
            fillOpacity={0.4}
          />
        </RadarChart>
      </ResponsiveContainer>
    </div>
  );
};
